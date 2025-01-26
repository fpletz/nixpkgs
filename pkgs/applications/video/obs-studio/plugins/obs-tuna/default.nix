{
  lib,
  stdenv,
  fetchFromGitHub,
  obs-studio,
  cmake,
  zlib,
  curl,
  dbus,
  pkg-config,
  qtbase,
  wrapQtAppsHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "obs-tuna";
  version = "1.9.9-unstable-2025-01-20";

  nativeBuildInputs = [
    cmake
    pkg-config
    wrapQtAppsHook
  ];
  buildInputs = [
    obs-studio
    qtbase
    zlib
    curl
    dbus
  ];

  src = fetchFromGitHub {
    owner = "univrsal";
    repo = "tuna";
    rev = "91fc3fd184fec472045ae6647b74c615f072bb54";
    hash = "sha256-akDWfNHPnW8t/WTAHi4kypQgmBcEs9+GGIrOs/VaD1U=";
    fetchSubmodules = true;
  };

  dontWrapQtApps = true;

  meta = {
    description = "Song information plugin for obs-studio";
    homepage = "https://github.com/univrsal/tuna";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ shortcord ];
    platforms = lib.platforms.linux;
  };
})
