{
  description = "ZaneyOS";

  inputs = {
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # helix.url = "github:helix-editor/helix/master";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-25_05.url = "github:NixOS/nixpkgs/nixos-25.05";
    nvf.url = "github:notashelf/nvf";
    stylix.url = "github:danth/stylix/master";
    nh = {
      url = "github:nix-community/nh";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      # helix,
      nh,
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
