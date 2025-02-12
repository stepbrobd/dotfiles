{
  services.fail2ban = {
    enable = true;

    bantime = "1h";
    bantime-increment = {
      enable = true;
      overalljails = true;
      maxtime = "168h"; # 7 * 24h
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
    };

    ignoreIP = [
      # local
      "127.0.0.0/8"
      "10.0.0.0/8"
      "172.16.0.0/12"
      "192.168.0.0/16"
      "169.254.0.0/16"
      "::1/128"
      "fe80::/10"
      "fc00::/7"
      # AS10779
      "23.161.104.0/24"
      "2620:BE:A000::/48"
      # Tailscale
      "100.64.0.0/10"
      "fd7a:115c:a1e0::/48"
      # Cloudflare IPv4: https://www.cloudflare.com/ips-v4
      "173.245.48.0/20"
      "103.21.244.0/22"
      "103.22.200.0/22"
      "103.31.4.0/22"
      "141.101.64.0/18"
      "108.162.192.0/18"
      "190.93.240.0/20"
      "188.114.96.0/20"
      "197.234.240.0/22"
      "198.41.128.0/17"
      "162.158.0.0/15"
      "104.16.0.0/13"
      "104.24.0.0/14"
      "172.64.0.0/13"
      "131.0.72.0/22"
      # Cloudflare IPv6: https://www.cloudflare.com/ips-v6
      "2400:cb00::/32"
      "2606:4700::/32"
      "2803:f800::/32"
      "2405:b500::/32"
      "2405:8100::/32"
      "2a06:98c0::/29"
      "2c0f:f248::/32"
    ];

    jails.sshd.settings.maxretry = 2;
  };
}
