{
  lib,
  stdenv,
  fetchgit,
  unstableGitUpdater,
  meson,
  ninja,
}:

stdenv.mkDerivation {
  pname = "edid-decode";
  version = "0-unstable-2024-09-03";

  outputs = [
    "out"
    "man"
  ];

  src = fetchgit {
    url = "https://git.linuxtv.org/edid-decode.git";
    rev = "88d457cbcabcc3ce25844b4b9e613f36914de156";
    hash = "sha256-DR03kjcnYTeJNpiYB8LAG61Wr7K9xDYToejwTTjg61Q=";
  };

  nativeBuildInputs = [
    meson
    ninja
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = with lib; {
    description = "EDID decoder and conformance tester";
    homepage = "https://git.linuxtv.org/edid-decode.git";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Madouura ];
    platforms = platforms.all;
    mainProgram = "edid-decode";
  };
}
