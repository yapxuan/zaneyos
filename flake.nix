{
  description = "ZaneyOS";

  inputs = {
    yazi.url = "github:sxyazi/yazi";

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
      url = "git+ssh://git@github.com/yapxuan/nix-secret.git?ref=main";
      flake = false;
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nixpkgs-2505.url = "github:nixos/nixpkgs/nixos-25.05";

    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
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
      mysecrets,
      agenix,
      nixpkgs,
      nh,
      hyprland,
      swww,
      chaotic,
      nur,
      lix,
      lix-module,
      yazi,
      nix-index-database,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "puiyq";
      flake_dir = "/home/${username}/zaneyos";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit
              inputs
              username
              host
              flake_dir
              ;
            profile = "amd";
            pkgs-stable = import inputs.nixpkgs-2505 {
              system = "x86_64-linux";
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
