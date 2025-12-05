# vendored from
# https://github.com/NixOS/nixpkgs/blob/master/pkgs/by-name/hy/hydra/package.nix
# local override for oidc

{ pkgs
, pkgsPrev ? pkgs
, lib
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
    paths =
      with (import ./perl.nix pkgs);
      lib.closePropagation [
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
        CatalystRuntime
        CatalystTraitForRequestProxyBase
        CatalystViewDownload
        CatalystViewJSON
        CatalystViewTT
        CatalystXRoleApplicator
        CatalystXScriptServerStarman
        CryptPassphrase
        CryptPassphraseArgon2
        CryptRandPasswd
        DBDPg
        DBDSQLite
        DBIxClassHelpers
        DataDump
        DateTime
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
        LWP
        LWPProtocolHttps
        ListSomeUtils
        ModulePluggable
        NetAmazonS3
        NetPrometheus
        NetStatsd
        NumberBytesHuman
        OIDCLite # <- this one
        PadWalker
        ParallelForkManager
        PerlCriticCommunity
        PrometheusTinyShared
        ReadonlyX
        SQLSplitStatement
        SetScalar
        Starman
        StringCompareConstantTime
        SysHostnameLong
        TermReadKey
        TermSizeAny
        Test2Harness
        TestPostgreSQL
        TestSimple13
        TextDiff
        TextTable
        UUID4Tiny
        XMLSimple
        YAML
        (nix.libs.nix-perl-bindings or nix.perl-bindings)
        git
      ];
  };

in
hydra.overrideAttrs (prev: {
  buildInputs = prev.buildInputs ++ [ perlDeps ];

  postInstall = ''
    mkdir -p $out/nix-support
    for i in $out/bin/*; do
        read -n 4 chars < $i
        if [[ $chars =~ ELF ]]; then continue; fi
        wrapProgram $i \
            --prefix PERL5LIB ':' "$out/libexec/hydra/lib:${perlPackages.makePerlPath [ perlDeps ]}" \
            --prefix PATH ':' $out/bin:$hydraPath \
            --set-default HYDRA_RELEASE ${prev.version} \
            --set HYDRA_HOME $out/libexec/hydra \
            --set NIX_RELEASE ${nix.name or "unknown"} \
            --set NIX_EVAL_JOBS_RELEASE ${nix-eval-jobs.name or "unknown"}
    done
  '';
})
