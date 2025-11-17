{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-configtool
        fcitx5-gtk
        fcitx5-mozc
        (fcitx5-rime.override { rimeDataPkgs = [ rime-data ]; })
        fcitx5-nord
        fcitx5-table-extra
      ];
      settings = {
        inputMethod = {
          GroupOrder."0" = "Default";
          "Groups/0" = {
            Name = "Default";
            "Default Layout" = "us";
            DefaultIM = "keyboard-us";
          };
          "Groups/0/Items/0".Name = "keyboard-us";
          "Groups/0/Items/1".Name = "mozc";
          "Groups/0/Items/2".Name = "rime";
        };

        globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = "True";
            AltTriggerKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateSkipFirst = "False";
            EnumerateGroupForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
            TogglePreedit = "";
            ModifierOnlyKeyTimeout = 250;
          };

          "Hotkey/PrevPage" = {
            "0" = "Up";
          };

          "Hotkey/NextPage" = {
            "0" = "Down";
          };

          "Hotkey/PrevCandidate" = {
            "0" = "Shift+Tab";
          };

          "Hotkey/NextCandidate" = {
            "0" = "Tab";
          };

          Behavior = {
            ActiveByDefault = "False";
            resetStateWhenFocusIn = "No";
            ShareInputState = "All";
            PreeditEnabledByDefault = "False";
            ShowInputMethodInformation = "True";
            showInputMethodInformationWhenFocusIn = "True";
            CompactInputMethodInformation = "True";
            ShowFirstInputMethodInformation = "True";
            DefaultPageSize = 5;
            OverrideXkbOption = "False";
            CustomXkbOption = "";
            EnabledAddons = "";
            PreloadInputMethod = "True";
            AllowInputMethodForPassword = "False";
            ShowPreeditForPassword = "False";
            AutoSavePeriod = 30;
          };
        };

        addons = {
          classicui.globalSection = {
            "Vertical Candidate List" = "True";
            WheelForPaging = "False";
            Font = "Sans Serif 12";
            MenuFont = "Sans Serif 12";
            TrayFont = "Sans Serif 12";
            TrayOutlineColor = "#000000";
            TrayTextColor = "#ffffff";
            PreferTextIcon = "False";
            ShowLayoutNameInIcon = "True";
            UseInputMethodLanguageToDisplayText = "False";
            Theme = "Nord-Dark";
            DarkTheme = "Nord-Dark";
            UseDarkTheme = "True";
            UseAccentColor = "True";
            PerScreenDPI = "True";
            ForceWaylandDPI = 0;
            EnableFractionalScale = "True";
          };

          keyboard.globalSection = {
            PageSize = 5;
            EnableEmoji = "False";
            EnableQuickPhraseEmoji = "False";
            "Choose Modifier" = "Alt";
            EnableHintByDefault = "False";
            "Hint Trigger" = "";
            "One Time Hint Trigger" = "";
            UseNewComposeBehavior = "True";
            EnableLongPress = "False";
            LongPressBlocklist = "";
          };

          keyboard.sections = {
            PrevCandidate = {
              "0" = "Shift+Tab";
            };
            NextCandidate = {
              "0" = "Tab";
            };
          };
        };
      };
    };
  };
}
