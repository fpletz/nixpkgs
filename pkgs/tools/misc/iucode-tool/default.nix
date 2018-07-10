{ lib, stdenv, fetchFromGitLab, autoreconfHook }:

stdenv.mkDerivation rec {
  name = "iucode-tool-${version}";
  version = "2.3.1";

  src = fetchFromGitLab {
    owner = "iucode-tool";
    repo = "iucode-tool";
    rev = "v${version}";
    sha256 = "04dlisw87dd3q3hhmkqc5dd58cp22fzx3rzah7pvcyij135yjc3a";
  };

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "Intel 64 and IA-32 processor microcode tool";
    longDescription = ''
      iucode_tool is a program to manipulate microcode update collections
      for Intel i686 and X86-64 system processors, and prepare them for use
      by the Linux kernel.
    '';
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ fpletz ];
    platforms = platforms.linux;
  };
}
