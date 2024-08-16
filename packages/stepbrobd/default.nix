{ lib, stdenv, writeShellScriptBin, symlinkJoin, makeWrapper, bash, curl, gh, git, jq, python311 }:


let
  pname = "stepbrobd";
  version = "2024.816.0";
  meta = {
    license = lib.licenses.mit;
    mainProgram = "stepbrobd";
    maintainers = [ lib.maintainers.stepbrobd ];
  };

  libexec = stdenv.mkDerivation {
    pname = "${pname}-libexec";
    inherit version;

    src = ./.;

    installPhase = ''
      mkdir -p $out/{bin,libexec}
      cp $src/*.{py,sh} $out/libexec
    '';
  };

  stepbrobd = writeShellScriptBin pname ''
    if [ "$1" = "discord" ]; then
      shift
      exec bash ${libexec}/libexec/discord.sh "$@"
    elif [ "$1" = "repo" ]; then
      shift
      exec python ${libexec}/libexec/repo.py "$@"
    elif [ "$1" = "sync" ]; then
      shift
      exec bash ${libexec}/libexec/sync.sh "$@"
    else
      echo "Usage: ${pname} {discord|repo|sync}"
      exit 1
    fi
  '';
in
lib.recursiveUpdate
  (symlinkJoin
  {
    name = "${pname}-${version}";
    paths = [ libexec stepbrobd ] ++ [ bash curl gh git jq python311 ];
    buildInputs = [ makeWrapper ];
    postBuild = "wrapProgram $out/bin/${pname} --prefix PATH : $out/bin";
  })
{ inherit meta; }
