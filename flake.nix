{
  description = "ZaneyOS";

  inputs = {
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
    rocm64 = {
      url = "github:LunNova/nixpkgs/lunnova/rocm-6.4.x";
      flake = false;
    };
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      #inputs.nixpkgs.follows = "nixpkgs";
      #inputs.home-manager.follows = "home-manager";
    };
    nixpkgs-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
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
    #xwayland-satellite = {
    #  url = "github:Supreeeme/xwayland-satellite";
    #  inputs.nixpkgs.follows = "nixpkgs";
    #};
    quickemu = {
      url = "github:quickemu-project/quickemu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      mysecrets,
      agenix,
      #xwayland-satellite,
      nixpkgs,
      nh,
      hyprland,
      swww,
      chaotic,
      nur,
      quickemu,
      rocm64,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      username = "puiyq";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            profile = "amd";
            pkgs-small = import inputs.nixpkgs-small {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
            rocm64 = import rocm64 {
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
