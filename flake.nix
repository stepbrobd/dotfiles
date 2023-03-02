{
  inputs = {
    dotfiles.url = "https://api.mynixos.com/stepbrobd/dotfiles/archive/main.tar.gz";
  };

  outputs = inputs@{ self, dotfiles, ... }:
    let
      filterAttrs = pred: set: builtins.listToAttrs (builtins.concatMap
        (name: let v = set.${name}; in if pred name v then [ ((name: value: { inherit name value; }) name v) ] else [ ])
        (builtins.attrNames set));
      forwardFlakeOutputs = input: filterAttrs (n: v: !(builtins.elem n [ "inputs" "outputs" "narHash" "outPath" "sourceInfo" ])) input;
    in
    forwardFlakeOutputs dotfiles;
}
