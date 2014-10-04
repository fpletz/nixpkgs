{ stdenv, fetchurl, fetchgit, go }:

stdenv.mkDerivation rec {
  name = "syncthing-${version}";
  version = "0.8.21";

  src = fetchgit {
    url = "git://github.com/syncthing/syncthing.git";
    rev = "refs/tags/vv${version}";
    sha256 = "40910eddd7dc02869ab13c6f69b41e9bc712d772a9cae0d4cb19a699580d35d7";
  };

  buildInputs = [ go ];

  buildPhase = ''
    mkdir -p "./dependencies/src/github.com/calmh/syncthing"

    for a in auto buffers cid discover files lamport protocol scanner \
            logger beacon config xdr upnp model osutil versioner; do
        cp -r "./$a" "./dependencies/src/github.com/calmh/syncthing"
    done

    export GOPATH="`pwd`/Godeps/_workspace:`pwd`/dependencies"

    go test -cpu=1,2,4 ./...

    mkdir ./bin

    go build -o ./bin/syncthing -ldflags "-w -X main.Version v${version}" ./cmd/syncthing
    go build -o ./bin/stcli -ldflags "-w -X main.Version v${version}" ./cmd/stcli
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r ./bin $out
  '';

  meta = {
    homepage = http://syncthing.net/;
    description = "Replaces Dropbox and BitTorrent Sync with something open, trustworthy and decentralized";
    license = with stdenv.lib.licenses; mit;
    maintainers = with stdenv.lib.maintainers; [ matejc ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
