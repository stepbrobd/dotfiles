# vendored from
# https://github.com/ners/hydra/blob/oidc/package.nix
# local override for oidc

{ pkgs
, pkgsPrev ? pkgs
, lib
, fetchFromGitHub
, buildEnv
, git
, nix
, nix-eval-jobs
, perlPackages
}:

let
  inherit (pkgsPrev) hydra;

  perlDeps = buildEnv {
    name = "hydra-perl-deps";
    paths = lib.closePropagation
      ([
        (nix.libs.nix-perl-bindings or nix.perl-bindings)
        git
      ] ++ (with (import ./perl-packages.nix pkgs); [
        AuthenSASL
        CatalystActionREST
        CatalystAuthenticationStoreDBIxClass
        CatalystAuthenticationStoreLDAP
        CatalystDevel
        CatalystPluginAccessLog
        CatalystPluginAuthorizationRoles
        CatalystPluginCaptcha
        CatalystPluginPrometheusTiny
        CatalystPluginSessionStateCookie
        CatalystPluginSessionStoreFastMmap
        CatalystPluginStackTrace
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXRoleApplicator
        CatalystXScriptServerStarman
        CryptPassphrase
        CryptPassphraseArgon2
        CryptRandPasswd
        DataDump
        DateTime
        DBDPg
        DBDSQLite
        DBIxClassHelpers
        DigestSHA1
        EmailMIME
        EmailSender
        FileCopyRecursive
        FileLibMagic
        FileSlurper
        FileWhich
        IOCompress
        IPCRun
        IPCRun3
        JSON
        JSONMaybeXS
        JSONXS
        ListSomeUtils
        LWP
        LWPProtocolHttps
        ModulePluggable
        NetAmazonS3
        NetPrometheus
        NetStatsd
        OIDCLite
        NumberBytesHuman
        PadWalker
        ParallelForkManager
        PerlCriticCommunity
        PrometheusTinyShared
        ReadonlyX
        SetScalar
        SQLSplitStatement
        Starman
        StringCompareConstantTime
        SysHostnameLong
        TermSizeAny
        TermReadKey
        Test2Harness
        TestPostgreSQL
        TextDiff
        TextTable
        UUID4Tiny
        YAML
        XMLSimple
      ]));
  };
in
hydra.overrideAttrs (final: prev: {
  pname = "hydra";
  version = prev.version + "-unstable-oidc";

  src = fetchFromGitHub {
    owner = "ners";
    repo = "hydra";
    rev = "a9c16a19518a238d74fce789e27dd166ef7058b1";
    hash = "sha256-Mhi3avp4xUcs73WRXm/sSmrBdfCAHDFaBZxuKA/9DCs=";
  };

  buildInputs = prev.buildInputs ++ [ perlDeps ];

  postInstall = ''
    mkdir -p $out/nix-support
    for i in $out/bin/*; do
      read -n 4 chars < $i
      if [[ $chars =~ ELF ]]; then continue; fi
      wrapProgram $i \
        --prefix PERL5LIB ':' "$out/libexec/hydra/lib:${perlPackages.makePerlPath [ perlDeps ]}" \
        --prefix PATH ':' $out/bin:$hydraPath \
        --set-default HYDRA_RELEASE ${final.version} \
        --set HYDRA_HOME $out/libexec/hydra \
        --set NIX_RELEASE ${nix.name or "unknown"} \
        --set NIX_EVAL_JOBS_RELEASE ${nix-eval-jobs.name or "unknown"}
    done
  '';

  dontStrip = true;
})
