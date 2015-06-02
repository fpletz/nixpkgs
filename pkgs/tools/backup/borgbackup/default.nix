{ stdenv, fetchFromGitHub, python3Packages, openssl, acl }:

python3Packages.buildPythonPackage rec {
  name = "borgbackup-git-2015-05-31";
  namePrefix = "";

  src = fetchFromGitHub {
    owner = "borgbackup";
    repo = "borg";
    rev = "8a5ddcfd19747d3baea49d8dd5f8abb968b6688f";
    sha256 = "1hfr8vx0vsn465zbq3mzvgspfkiald6y8xxlkgkzln1z9h7j4sxk";
  };

  propagatedBuildInputs = with python3Packages;
    [ cython msgpack openssl acl llfuse ];

  preConfigure = ''
    export BORG_OPENSSL_PREFIX="${openssl}"
  '';

  meta = with stdenv.lib; {
    description = "A deduplication backup program";
    homepage = "https://attic-backup.org";
    license = licenses.bsd3;
    maintainers = [ maintainers.wscott ];
    platforms = platforms.unix; # Darwin and FreeBSD mentioned on homepage
  };
}
