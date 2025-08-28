{ lib, ... }:

{
  boot.kernelPatches = lib.singleton {
    name = "ebpf-config";
    patch = null;
    structuredExtraConfig = with lib.kernel; {
      BPF_KPROBE_OVERRIDE = yes;
      FUNCTION_ERROR_INJECTION = yes;
    };
  };
}
