{ stdenv, fetchurl, libotr, pidgin, intltool } :

stdenv.mkDerivation rec {
  name = "pidgin-otr-4.0.1";
  src = fetchurl {
    url = "http://www.cypherpunks.ca/otr/${name}.tar.gz";
    sha256 = "02pkkf86fh5jvzsdn9y78impsgzj1n0p81kc2girvk3vq941yy0v";
  };

  postInstall = "ln -s \$out/lib/pidgin \$out/share/pidgin-otr";

  buildInputs = [ libotr pidgin intltool ];

  meta = {
    homepage = http://www.cypherpunks.ca/otr;
    description = "Plugin for Pidgin 2.x which implements OTR Messaging";
    license = stdenv.lib.licenses.gpl2;
  };
}
