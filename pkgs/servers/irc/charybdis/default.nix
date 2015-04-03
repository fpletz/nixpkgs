{ stdenv, fetchFromGitHub, zlib, libressl, bison, flex, sqlite }:

stdenv.mkDerivation rec {
  name = "charybdis-3.5.0-rc1-a0eb676";

  src = fetchFromGitHub {
    owner = "darkfasel";
    repo = "charybdis";
    rev = "a0eb6762559497dbbcd4a712ae47b5455a59a56c";
    sha256 = "1wc5zbxj2xv2dq0zswpavlcn4h7c4160s74677bql5xpjqjfixkw";
  };

  configureFlags = [
    "--sysconfdir=/etc/charybdis"
    "--localstatedir=/var"
    "--disable-assert"
    "--enable-openssl=${libressl}"
    "--enable-ipv6"
    "--with-shared-sqlite"
    "--with-program-prefix=charybdis-"
  ];

  buildInputs = [ zlib libressl bison flex sqlite ];

  enableParallelBuilding = true;

  meta = {
    description = "Charybdis IRC Daemon";
    homepage    = http://www.atheme.org/projects/charybdis.html;
    license     = stdenv.lib.licenses.gpl2;
    maintainers = [ stdenv.lib.maintainers.fpletz ];
    platforms   = stdenv.lib.platforms.all;
  };
}
