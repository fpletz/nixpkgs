x@{builderDefsPackage
  , unzip
  , ...}:
builderDefsPackage
(a :
let
  helperArgNames = ["stdenv" "fetchurl" "builderDefsPackage"] ++
    [];

  buildInputs = map (n: builtins.getAttr n x)
    (builtins.attrNames (builtins.removeAttrs x helperArgNames));
  sourceInfo = rec {
    version = "1.017";
    name = "source-code-pro";
    url = "https://github.com/adobe-fonts/source-code-pro/archive/${version}R.zip";
    hash = "0igcr4xj36ky7w356s1a3v6j2s17z5k8s3iabbl1g88iyjr6ac0c";
  };
in
rec {
  src = a.fetchurl {
    url = sourceInfo.url;
    sha256 = sourceInfo.hash;
  };

  name = "${sourceInfo.name}-${sourceInfo.version}";
  inherit buildInputs;

  phaseNames = ["doUnpack" "installFonts"];

  doUnpack = a.fullDepEntry (''
    unzip ${src}
    cd ${sourceInfo.name}*/OTF/
  '') ["addInputs"];

  meta = {
    description = "A set of monospaced OpenType fonts designed for coding environments";
    maintainers = with a.lib.maintainers; [ relrod ];
    platforms = with a.lib.platforms; all;
    homepage = "http://blog.typekit.com/2012/09/24/source-code-pro/";
    license = a.lib.licenses.ofl;
  };
}) x
