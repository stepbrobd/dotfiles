{ ... }:

{
  resource.fastly_ngwaf_workspace.ngwaf = {
    name = "NGWAF";
    description = "Next-Gen WAF";
    mode = "block";

    # this block is required
    attack_signal_thresholds = [{
      immediate = true;
      one_minute = 50;
      ten_minutes = 350;
      one_hour = 1800;
    }];
  };
}
