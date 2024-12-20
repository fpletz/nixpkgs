{
  lib,
  stdenv,
  fetchFromGitea,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dev86";
  version = "1.0.1";

  src = fetchFromGitea {
    domain = "codeberg.org";
    owner = "jbruchon";
    repo = "dev86";
    tag = finalAttrs.version;
    hash = "sha256-CWeboFkJkpKHZ/wkuvMj5a+5qB2uzAtoYy8OdyYErMg=";
  };

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=implicit-int -Wno-error=implicit-function-declaration";

  # Parallel builds are not supported due to build process structure: tools are
  # built sequentially in submakefiles and are reusing the same targets as
  # dependencies. Building dependencies in parallel from different submakes is
  # not synchronized and fails:
  #     make[3]: Entering directory '/build/dev86-0.16.21/libc'
  #     Unable to execute as86.
  #enableParallelBuilding = false;

  meta = {
    homepage = "https://github.com/jbruchon/dev86";
    description = "C compiler, assembler and linker environment for the production of 8086 executables";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [
      AndersonTorres
      sigmasquadron
    ];
    platforms = lib.platforms.linux;
  };
})
