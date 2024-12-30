{ inputs, ... }:

{
  imports = with inputs.self.homeManagerModules.ysun; [ starship ];

  programs.carapace.enable = true;

  programs.nushell = {
    enable = true;
    configFile.text = /* nu */ ''
      $env.config = {
        edit_mode: vi
        show_banner: false
      }
      $env.PROMPT_COMMAND = ""
      $env.PROMPT_COMMAND_RIGHT = ""
      $env.PROMPT_INDICATOR = ""
      $env.PROMPT_INDICATOR_VI_INSERT = ""
      $env.PROMPT_INDICATOR_VI_NORMAL = ""
      $env.PROMPT_MULTILINE_INDICATOR = ""
    '';
  };
}
