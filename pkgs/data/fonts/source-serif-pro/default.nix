{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation {
  name = "source-serif-pro-1.017";
  src = fetchurl {
    url = "https://github.com/adobe-fonts/source-serif-pro/archive/1.017R.tar.gz";
    sha256 = "04h24iywjl4fd08x22ypdb3sm979wjfq4wk95r3rk8w376spakrg";
  };

  buildInputs = [ unzip ];

  phases = "unpackPhase installPhase";

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    find . -name "*.otf" -exec cp {} $out/share/fonts/opentype \;
  '';

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/adobe/sourceserifpro;
    description = "A set of OpenType fonts to complement Source Sans Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}

