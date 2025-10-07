{
  description = "ZaneyOS";

  inputs = {
    firmware.url = "github:nixos/nixpkgs/1273efa67f5ea516eebc3332e538437d2f00b25c";
    flake-utils.follows = "yazi/flake-utils";
    flake-compat.follows = "nvf/flake-compat";
    systems.follows = "hyprland/systems";
    gitignore.follows = "hyprland/pre-commit-hooks/gitignore";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
    };

    zls = {
      url = "github:zigtools/zls";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig-overlay.follows = "zig";
        gitignore.follows = "gitignore";
      };
    };

    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        zig.follows = "zig";
        zon2nix.follows = "zon2nix";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    zon2nix = {
      url = "github:jcollie/zon2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig = {
      #block untill https://github.com/zigtools/zls/pull/2457 merged
      #url = "github:silversquirl/zig-flake";
      url = "github:mitchellh/zig-overlay";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        flake-compat.follows = "flake-compat";
        flake-utils.follows = "flake-utils";
      };
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi = {
      url = "github:sxyazi/yazi";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
      };
    };

    #lix = {
    #  url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
    #  flake = false;
    #};

    #lix-module = {
    # url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
    # inputs = {
    #    nixpkgs.follows = "nixpkgs";
    #   lix.follows = "lix";
    #   flake-utils.inputs.systems.follows = "systems";
    # };
    #};

    ragenix = {
      url = "github:yaxitech/ragenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-utils.follows = "flake-utils";
        agenix.follows = "agenix";
      };
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
        systems.follows = "systems";
      };
    };

    mysecrets = {
      url = "git+ssh://git@github.com/yapxuan/nix-secret.git?shallow=1";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.rust-overlay.follows = "rust-overlay";
      inputs.home-manager.follows = "home-manager";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };

    stylix = {
      url = "github:danth/stylix/master";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        # nur.follows = "nur";
        systems.follows = "systems";
        flake-parts.follows = "flake-parts";
      };
    };

    swww = {
      url = "github:LGFae/swww";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        rust-overlay.follows = "rust-overlay";
        flake-compat.follows = "flake-compat";
      };
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
    };

    #nur = {
    # url = "github:nix-community/NUR";
    # inputs.nixpkgs.follows = "nixpkgs";
    # inputs.flake-parts.follows = "flake-parts";
    #};

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      treefmt-nix,
      rust-overlay,
      zig,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "puiyq";
      flake_dir = "/home/${username}/zaneyos";
      pkgs = import nixpkgs {
        inherit system;
        config = {
          rocmSupport = true;
          allowUnfree = true;
        };
        overlays = [
          (final: _prev: {
            animeko = final.callPackage ./pkgs/animeko { };
          })
          rust-overlay.overlays.default
          zig.overlays.default
        ];
      };
    in
    {
      packages.${system} = {
        inherit (pkgs) animeko;
      };
      templates.treefmt = {
        path = ./templates/treefmt;
        description = "Minimal treefmt-nix";
      };
      formatter.${system} = treefmt-nix.lib.mkWrapper pkgs ./treefmt.nix;
      checks.${system} = {
        treefmt = self.formatter.${system};
      };
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              username
              host
              flake_dir
              system
              ;
            profile = "amd";
            firmware = import inputs.firmware {
              inherit system;
            };
          };
          modules = [
            ./profiles/amd
          ];
        };
      };
      devShells.${system} = {
        haskell = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            ghc
            cabal-install
            haskellPackages.haskell-language-server
          ];
        };
        fortran = pkgs.mkShell {
          nativeBuildInputs = with pkgs; [
            gfortran
          ];
        };
        zig = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            zigpkgs.master
          ];
        };
        go = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            go
          ];
          shellHook = ''
            export CC=clang
            export CXX=clang++
            export CGO_CFLAGS="-O2 -march=native -g"
            export CGO_CXXFLAGS="-O2 -march=native -g"
            export GOAMD64=v4
          '';
        };
        python = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          nativeBuildInputs = with pkgs; [
            (python3.override {
              enableOptimizations = true;
              reproducibleBuild = false;
            })
          ];
          shellHook = ''export LD_LIBRARY_PATH=$NIX_LD_LIBRARY_PATH:$LD_LIBRARY_PATH'';
        };
        c = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          buildInputs = [
            pkgs.SDL2
          ];
        };
        rust = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          buildInputs = [
            pkgs.rustlings
          ];
          nativeBuildInputs = [
            (pkgs.rust-bin.selectLatestNightlyWith (
              toolchain: toolchain.default
              #.override {
              #  extensions = [
              #   "llvm-tools"
              #   "rust-src"
              # ];
              #}
            ))
          ];
        };
      };
    };
}
