{stdenv, fetchurl, groff}:

stdenv.mkDerivation rec {
  name = "mksh-${version}";
  version = "R50b";

  src = fetchurl {
    url = "https://www.mirbsd.org/MirOS/dist/mir/mksh/${name}.tgz";
    sha256 = "51ff2f8b6450f50823f42b8f2431a0f17c40c9f2b0f83e15aa0d05a09627cd49";
  };

  buildInputs = [ groff ];

  buildPhase = ''
    /bin/sh Build.sh
  '';

  installPhase = ''
    mkdir -p $out/bin
    install -c -s -m 555 mksh $out/bin/mksh
    mkdir -p $out/share/doc/mksh/examples/
    install -c -m 444 dot.mkshrc $out/share/doc/mksh/examples/
    mkdir -p $out/share/man/man1
    install -c -m 444 mksh.1 $out/share/man/man1/mksh.1
  '';

  meta = with stdenv.lib; {
    homepage = "https://www.mirbsd.org/mksh.htm";
    description = "MirBSD™ Korn Shell, an actively developed successor to the Public Domain Korn Shell (pdksh).";
    license = licenses.isc;
    platforms = platforms.unix;
    maintainers = with maintainers; [ fpletz ];
  };
}
