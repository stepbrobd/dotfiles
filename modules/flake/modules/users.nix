{ modulesFor, ... }:

# only put user shell and other metadata like group membership in there
# should be compatible with nixos/darwin modules
{ flake.userModules = modulesFor "users"; }
