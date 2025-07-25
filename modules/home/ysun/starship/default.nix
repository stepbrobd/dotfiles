{ lib, ... }:

{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_state"
        "$git_status"
        "$fill"
        "$cmd_duration"
        "$hostname"
        "$direnv"
        "$nix_shell"
        "$line_break"
        "$character"
      ];

      directory = {
        disabled = false;
        format = "[$read_only]($read_only_style)[$path]($style) ";
        style = "cyan";
        read_only = "!w ";
        read_only_style = "red";
        truncate_to_repo = false;
        truncation_length = 5;
        truncation_symbol = ".../";
      };

      git_branch = {
        disabled = false;
        format = "[$branch]($style) ";
        style = "green";
      };

      git_commit = {
        disabled = false;
        tag_disabled = false;
        style = "green";
        tag_symbol = "@";
      };

      git_state = {
        disabled = false;
        style = "red";
      };

      git_status = {
        disabled = false;
        format = "$all_status$ahead_behind";
        conflicted = "[=\${count}](red) ";
        ahead = "[>\${count}](green) ";
        behind = "[<\${count}](yellow) ";
        diverged = "[>\${ahead_count}](green) [<\${behind_count}](yellow) ";
        untracked = "[?\${count}](cyan) ";
        stashed = "[*\${count}](green) ";
        modified = "[!\${count}](yellow) ";
        staged = "[+\${count}](yellow) ";
        renamed = "[r\${count}](purple) ";
        deleted = "[x\${count}](red) ";
      };

      fill = {
        disabled = false;
        symbol = ".";
        style = "black";
      };

      cmd_duration = {
        disabled = false;
        format = "[$duration]($style) ";
        style = "blue";
        min_time = 0;
        show_milliseconds = true;
      };

      hostname = {
        disabled = false;
        format = "[$hostname]($style) ";
        style = "purple";
        ssh_only = true;
      };

      direnv = {
        disabled = false;
        format = "[$symbol]($style) ";
        symbol = "direnv";
        style = "yellow";
      };

      nix_shell = {
        disabled = false;
        format = "[$symbol$state]($style) ";
        symbol = "nix ";
        impure_msg = "impure";
        pure_msg = "pure";
        unknown_msg = "shell";
        style = "cyan";
      };

      character = {
        disabled = false;
        format = "$symbol ";
        success_symbol = "[\\$](green)";
        error_symbol = "[\\$](red)";
        vimcmd_symbol = "[\\$](green)";
        vimcmd_replace_one_symbol = "[\\$](purple)";
        vimcmd_replace_symbol = "[\\$](purple)";
        vimcmd_visual_symbol = "[\\$](yellow)";
      };
    };
  };
}
