{ pkgs, ... }:

{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = true;
      addons = with pkgs; [
        qt6Packages.fcitx5-configtool
        qt6Packages.fcitx5-chinese-addons
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
          "Groups/0/Items/3".Name = "pinyin";
        };

        globalOptions = {
          Hotkey = {
            EnumerateWithTriggerKeys = "True";
            TriggerKeys = "";
            AltTriggerKeys = "";
            EnumerateBackwardKeys = "";
            EnumerateSkipFirst = "False";
            EnumerateGroupForwardKeys = "";
            EnumerateGroupBackwardKeys = "";
            TogglePreedit = "";
            ModifierOnlyKeyTimeout = 250;
          };

          # keyd caps tap emits F13 = XF86Tools (fcitx5 names "Tools")
          "Hotkey/EnumerateForwardKeys" = {
            "0" = "Tools";
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
            ShareInputState = "No";
            PreeditEnabledByDefault = "True";
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
            WheelForPaging = "True";
            Font = "Sans 10";
            MenuFont = "Sans 10";
            TrayFont = "Sans Bold 10";
            TrayOutlineColor = "#000000";
            TrayTextColor = "#ffffff";
            PreferTextIcon = "False";
            ShowLayoutNameInIcon = "True";
            UseInputMethodLanguageToDisplayText = "True";
            Theme = "Nord-Dark";
            DarkTheme = "Nord-Dark";
            UseDarkTheme = "False";
            UseAccentColor = "True";
            PerScreenDPI = "False";
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

  # caps lock:
  # <75ms graze = nothing (HID brush guard)
  # tap = f13 (fcitx5 trigger)
  # >=500ms hold = caps lock
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        capslock = "timeout(noop, 75, timeout(f13, 425, capslock))";
      };
    };
  };
}
