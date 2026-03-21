{ inputs, ... }:

{
  name = "ripe-atlas-software-probe";

  nodes.machine =
    { pkgs, ... }:
    {
      imports = [ inputs.self.nixosModules.ripe-atlas-software-probe ];

      services.ripe-atlas-software-probe.enable = true;

      # block outbound ssh to ripe registration servers so ssh fails fast
      # instead of hanging and OOM-ing the VM via QEMU usermode networking
      networking.firewall.extraCommands = ''
        iptables -A OUTPUT -p tcp --dport 443 -j REJECT
        ip6tables -A OUTPUT -p tcp --dport 443 -j REJECT
      '';

      environment.systemPackages = with pkgs; [
        ripe-atlas-software-probe
        ripe-atlas-probe-measurements
      ];
    };

  testScript = ''
    machine.wait_for_unit("multi-user.target")

    # users and groups
    machine.succeed("getent group ripe-atlas")
    machine.succeed("getent passwd ripe-atlas")

    # spool directories created by tmpfiles
    for d in [
      "/var/spool/ripe-atlas",
      "/var/spool/ripe-atlas/data",
      "/var/spool/ripe-atlas/data/new",
      "/var/spool/ripe-atlas/data/out",
      "/var/spool/ripe-atlas/crons",
      "/var/spool/ripe-atlas/crons/main",
      "/etc/ripe-atlas",
    ]:
      machine.succeed(f"test -d {d}")

    # runtime directory managed by systemd
    machine.succeed("test -d /run/ripe-atlas")

    # writable config dir has mode file from ExecStartPre
    machine.succeed("test -f /etc/ripe-atlas/mode")

    # ssh keys were generated in writable config dir
    machine.wait_until_succeeds("test -f /etc/ripe-atlas/probe_key", timeout=15)
    machine.succeed("test -f /etc/ripe-atlas/probe_key.pub")

    # reg_servers.sh was copied based on mode
    machine.succeed("test -f /etc/ripe-atlas/reg_servers.sh")

    # probe orchestrator and measurement tools available
    machine.succeed("which ripe-atlas")
    for tool in ["perd", "eperd", "eooqd", "evping", "evtdig", "evtraceroute", "telnetd"]:
      machine.succeed(f"which {tool}")

    # baked-in paths point to correct runtime locations
    probe_store = machine.succeed("readlink -f $(which ripe-atlas)").strip()
    probe_prefix = "/".join(probe_store.split("/")[:4])
    out = machine.succeed(f"cat {probe_prefix}/libexec/ripe-atlas/scripts/paths.lib.sh")
    assert "/var/spool/ripe-atlas" in out, "ATLAS_SPOOLDIR not set correctly"
    assert "/run/ripe-atlas" in out, "ATLAS_RUNDIR not set correctly"

    # service is active and running
    machine.wait_for_unit("ripe-atlas-software-probe.service")
    status = machine.succeed("systemctl is-active ripe-atlas-software-probe.service").strip()
    assert status == "active", f"expected active, got {status}"

    # wait for the probe to attempt registration (ssh will be rejected fast)
    machine.wait_until_succeeds(
      "journalctl -u ripe-atlas-software-probe -n 50 --no-pager | grep -q 'ATLAS registration starting'",
      timeout=15,
    )

    # no measurement tool path errors or setresuid failures
    machine.fail("journalctl -u ripe-atlas-software-probe -n 100 --no-pager | grep -q '/nix/store.*No such file or directory'")
    machine.fail("journalctl -u ripe-atlas-software-probe -n 100 --no-pager | grep -q 'setresuid: Operation not permitted'")

    # probe should still be running after the failed registration attempt
    status = machine.succeed("systemctl is-active ripe-atlas-software-probe.service").strip()
    assert status == "active", f"expected active after registration attempt, got {status}"
  '';
}
