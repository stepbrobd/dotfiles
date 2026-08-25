// typenix declarations (https://github.com/ryanrasti/typenix)

// Lib = nixpkgs lib + autopilot extensions + lib/*.nix

/*   @ts: import type { Lib } from "./type.nix.d.ts"; */
// # @ts: { lib: Lib }

// derived from files where possible
import type { default as DeepMergeAttrsList } from "./deep-merge-attrs-list.nix";
import type { default as GenHostModules } from "./gen-host-modules.nix";
import type { default as GenUserModules } from "./gen-user-modules.nix";
import type { default as ImportPackagesTree } from "./import-packages-tree.nix";
import type { default as LocalPackagesFrom } from "./local-packages-from.nix";
import type { default as MkColmena } from "./mk-colmena.nix";
import type { default as MkDynamicAttrs } from "./mk-dynamic-attrs.nix";
import type { default as Blueprint } from "./blueprint/default.nix";
import type { default as Terranix } from "./terranix/default.nix";

// detailed annotations for simple lambdas (typenix exports their params as any)
type IncLib = Lib & {
  childDirsWithDefault: (dir: string | Path) => string[];
  deepMergeAttrsList: ReturnType<typeof DeepMergeAttrsList>;
  expandIpv6: (addr: string) => string;
  genHostModules: ReturnType<typeof GenHostModules>;
  genUserModules: ReturnType<typeof GenUserModules>;
  hasTag: (hostName: string) => (tag: string) => boolean;
  importApplyWithArgs: (
    modulePath: Path,
  ) => (staticArgs: Record<string, any>) => any;
  importPackagesTree: ReturnType<typeof ImportPackagesTree>;
  ipv4ToRdns: (addr: string) => string;
  ipv6ToRdns: (addr: string) => string;
  localPackagesFrom: ReturnType<typeof LocalPackagesFrom>;
  mkColmena: ReturnType<typeof MkColmena>;
  mkDynamicAttrs: ReturnType<typeof MkDynamicAttrs>;
  zoneSlug: (zone: string) => string;
  blueprint: ReturnType<typeof Blueprint>;
  terranix: ReturnType<typeof Terranix>;

  // autopilot lib extensions
  loadAll: (
    args: { dir: string | Path; args?: Record<string, any> },
  ) => Record<string, any>;
};

export type { IncLib as Lib };
