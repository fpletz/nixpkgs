{ config
, lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, obs-studio
, onnxruntime
, opencv
, qt6
, curl
, withCUDA ? config.cudaSupport
, cudaPackages
}:

stdenv.mkDerivation rec {
  pname = "obs-backgroundremoval";
  version = "1.1.13";

  src = fetchFromGitHub {
    owner = "occ-ai";
    repo = "obs-backgroundremoval";
    rev = version;
    hash = "sha256-QoC9/HkwOXMoFNvcOxQkGCLLAJmsja801LKCNT9O9T0=";
  };

  nativeBuildInputs = [ cmake ninja ];
  buildInputs = [ obs-studio onnxruntime opencv qt6.qtbase curl ]
  ++ lib.optionals withCUDA [
    cudaPackages.cuda_nvcc
    cudaPackages.cuda_cudart
  ];

  dontWrapQtApps = true;

  cmakeFlags = [
    "--preset linux-x86_64"
    "-DCMAKE_MODULE_PATH:PATH=${src}/cmake"
    "-DUSE_SYSTEM_ONNXRUNTIME=ON"
    "-DUSE_SYSTEM_OPENCV=ON"
  ] ++ lib.optionals withCUDA [
    "-DCUDA_TOOLKIT_ROOT_DIR=${cudaPackages.cuda_cudart}"
  ];

  buildPhase = ''
     cd ..
     cmake --build build_x86_64 --parallel
  '';

  installPhase = ''
    cmake --install build_x86_64 --prefix "$out"
  '';

  meta = with lib; {
    description = "OBS plugin to replace the background in portrait images and video";
    homepage = "https://github.com/royshil/obs-backgroundremoval";
    maintainers = with maintainers; [ zahrun ];
    license = licenses.mit;
    platforms = [ "x86_64-linux" ];
  };
}
