{
  description = "ZaneyOS";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    nixpkgs-25_05.url = "github:NixOS/nixpkgs/nixos-25.05";
    nvf = {
      url = "github:notashelf/nvf";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix/master";
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    swww = {
      url = "github:LGFae/swww";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland.url = "github:hyprwm/Hyprland";
  };

  outputs =
    {
      nixpkgs,
      # helix,
      nh,
      hyprland,
      swww,
      chaotic,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      host = "nixos";
      profile = "amd";
      username = "puiyq";
    in
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      nixosConfigurations = {
        amd = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit profile;
            pkgs-25_05 = import inputs.nixpkgs-25_05 {
              system = "x86_64-linux";
              config.allowUnfree = true;
            };
          };
          modules = [ ./profiles/amd ];
        };
        nvidia = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit profile;
          };
          modules = [ ./profiles/nvidia ];
        };
        nvidia-laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit profile;
          };
          modules = [ ./profiles/nvidia-laptop ];
        };
        intel = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit profile;
          };
          modules = [ ./profiles/intel ];
        };
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs;
            inherit username;
            inherit host;
            inherit profile;
          };
          modules = [ ./profiles/vm ];
        };
      };
    };
}
