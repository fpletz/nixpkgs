{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "source-sans-pro-1.065";
  src = fetchurl {
    url = "https://github.com/adobe-fonts/source-sans-pro/archive/2.010R-ro/1.065R-it.zip";
    sha256 = "1g1r611f76haflw2cicn63fsrh36psr57v3xwyi0lgwzpzj8all4";
  };

  buildInputs = [ unzip ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/adobe/sourcesans;
    description = "A set of OpenType fonts designed by Adobe for UIs";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}
