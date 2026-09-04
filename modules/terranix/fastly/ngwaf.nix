{ ... }:

{
  resource.fastly_ngwaf_workspace.ngwaf = {
    name = "NGWAF";
    description = "Next-Gen WAF";
    mode = "log";

    # this block is required
    attack_signal_thresholds = [{
      immediate = false;
      one_minute = 1;
      ten_minutes = 60;
      one_hour = 100;
    }];
  };
}
