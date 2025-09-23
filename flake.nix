{
  description = "ZaneyOS";

  inputs = {
    zls = {
      url = "github:zigtools/zls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty = {
      url = "github:ghostty-org/ghostty";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.zig.follows = "zig";
    };

    zon2nix = {
      url = "github:jcollie/zon2nix?rev=bf983aa90ff169372b9fa8c02e57ea75e0b42245";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    yazi = {
      url = "github:sxyazi/yazi";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.lix.follows = "lix";
    };

    agenix = {
      url = "github:yaxitech/ragenix";
      inputs.nixpkgs.follows = "nixpkgs";
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

    mt7921e-firmware.url = "github:nixos/nixpkgs/1273efa67f5ea516eebc3332e538437d2f00b25c";

    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    swww = {
      url = "github:LGFae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.rust-overlay.follows = "rust-overlay";
    };

    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      mysecrets,
      zls,
      prismlauncher,
      agenix,
      nixpkgs,
      nh,
      zig,
      hyprland,
      ghostty,
      swww,
      chaotic,
      nur,
      lix,
      lix-module,
      yazi,
      nix-index-database,
      treefmt-nix,
      rust-overlay,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "puiyq";
      flake_dir = "/home/${username}/zaneyos";
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          (final: _prev: {
            animeko = final.callPackage ./pkgs/animeko { };
          })
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
            firmware = import inputs.mt7921e-firmware {
              inherit system;
              config.allowUnfree = true;
            };
          };
          modules = [
            ./profiles/amd
          ];
        };
      };
    };
}
