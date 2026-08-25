/* @ts: import type { Lib } from "./type.nix.d.ts"; */
# @ts: { lib: Lib }
{ lib }:

# convert a zone name to its resource slug ("-"/"." -> "_")
# "ysun.co"                  -> "co_ysun"
# "136.104.192.in-addr.arpa" -> "arpa_in_addr_192_104_136"
# @ts: (zone: string) => string
zone:
lib.replaceStrings [ "-" ] [ "_" ]
  (lib.concatStringsSep "_" (lib.reverseList (lib.splitString "." zone)))
