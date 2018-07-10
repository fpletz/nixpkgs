{ stdenv, fetchurl, iucode_tool }:

let

  version = "20180703";
  debianVersion = "3.${version}.2";

  microcodeFile = if stdenv.system == "x86_64-linux"
    then "intel-microcode-64.bin"
    else "intel-microcode.bin";

in stdenv.mkDerivation {
  name = "microcode-intel-${version}";

  src = fetchurl {
    url = "https://salsa.debian.org/hmh/intel-microcode/-/archive/debian/3.20180703.2/intel-microcode-debian-.tar.gz";
    sha256 = "0x0ahki6qkj1sj6iwpvi8k7v7rid7qj2xglblap2kypszgyzn4h8";
  };

  nativeBuildInputs = [ iucode_tool ];

  postBuild = ''
    iucode_tool --write-earlyfw=intel-ucode.img ${microcodeFile}
  '';

  installPhase = ''
    install -D -t $out intel-ucode.img
  '';

  meta = with stdenv.lib; {
    homepage = http://www.intel.com/;
    description = "Microcode for Intel processors";
    license = licenses.unfreeRedistributableFirmware;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
