# vendored from https://github.com/NixOS/nixpkgs/pull/398456

{ lib }:

with lib;
/**
  Return a module that causes a warning to be shown if the
  specified option is defined. For example,

      mkRemovedOptionModule [ "boot" "loader" "grub" "bootDevice" ] "<replacement instructions>"

  causes a assertion if the user defines boot.loader.grub.bootDevice.

  replacementInstructions is a string that provides instructions on
  how to achieve the same functionality without the removed option,
  or alternatively a reasoning why the functionality is not needed.
  replacementInstructions SHOULD be provided!

  # Inputs

  `optionName`

  : 1\. Function argument

  `replacementInstructions`

  : 2\. Function argument
  */
optionName: replacementInstructions:
{ options, ... }:
{
  key = "removedOptionModule#" + concatStringsSep "_" optionName;
  options = setAttrByPath optionName (mkOption {
    visible = false;
    apply =
      x:
      throw "The option `${showOption optionName}' can no longer be used since it's been removed. ${replacementInstructions}";
  });
  config.assertions =
    let
      opt = getAttrFromPath optionName options;
    in
    [
      {
        assertion = !opt.isDefined;
        message = ''
          The option definition `${showOption optionName}' in ${showFiles opt.files} no longer has any effect; please remove it.
          ${replacementInstructions}
        '';
      }
    ];
}
