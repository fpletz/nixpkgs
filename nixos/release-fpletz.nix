{ nixpkgs ? { outPath = ./..; revCount = 56789; shortRev = "gfedcba"; }
, system ? "x86_64-linux"
}:

let
  nixpkgsSrc = nixpkgs; # urgh

  nixos' = import ./release.nix {
    supportedSystems = [ system ];
    stableBranch = true;
    nixpkgs = nixpkgsSrc;
  };

  lib = (import ./.. {}).lib;

  containerModule = ./modules/virtualisation/lxc-container.nix;

  versionModule =
    { system.nixosVersionSuffix = ".${toString nixpkgs.revCount}.${nixpkgs.shortRev}";
      system.nixosRevision = nixpkgs.rev or nixpkgs.shortRev;
    };

  minimalModule =
    { services =
      { atd.enable = false;
        ntp.enable = false;
      };
      security.polkit.enable = false;
      time.timeZone = "UTC";
      networking.firewall.allowPing = true;
    };

  makeConfig = module: (import lib/eval-config.nix {
      inherit system;
      modules = [ module minimalModule containerModule versionModule ];
    }).config;

  makeClosure = module: (makeConfig module).system.build.toplevel;

  makeContainerTarball = module:
    let
      meta =
        { description = "NixOS system tarball for ${system}";
          maintainers = lib.maintainers.fpletz;
        };

      tarball = (makeConfig module).system.build.tarball;

    in
      tarball // { inherit meta; };

in rec {

  inherit (nixos') channel manual containerTarball;

  minimalTarball = makeContainerTarball {};

  standardTarball = makeContainerTarball
    { services =
        { openssh =
            { enable = true;
                hostKeys =
                [ { type = "ed25519";
                    path = "/etc/ssh/ssh_host_ed25519_key";
                    bits = 256;
                  }
                ];
            };
        };

    };

}
