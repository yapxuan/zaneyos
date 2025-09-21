{ host, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) consoleKeyMap;
in
{
  nix = {
    settings = {
      #download-buffer-size = 250000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      substituters = [
        "https://hyprland.cachix.org"
        "https://cache.nixos.org/"
        "https://puiyq.cachix.org"
        "https://nix-community.cachix.org"
        "https://chaotic-nyx.cachix.org/"
        "https://yazi.cachix.org"
        "https://nvf.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "puiyq.cachix.org-1:x3l4E/KXWxCSELeZlxB52NVOfof240vPjIZUEQp5RHw="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "yazi.cachix.org-1:Dcdz63NZKfvUCbDGngQDAZq6kOroIrFoyO064uvLh8k="
        "nvf.cachix.org-1:GMQWiUhZ6ux9D5CvFFMwnc2nFrUHTeGaXRlVBXo+naI="
      ];
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
  time.timeZone = "Asia/Kuching";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ms_MY.UTF-8";
    LC_IDENTIFICATION = "ms_MY.UTF-8";
    LC_MEASUREMENT = "ms_MY.UTF-8";
    LC_MONETARY = "ms_MY.UTF-8";
    LC_NAME = "ms_MY.UTF-8";
    LC_NUMERIC = "ms_MY.UTF-8";
    LC_PAPER = "ms_MY.UTF-8";
    LC_TELEPHONE = "ms_MY.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  environment.variables = {
    ZANEYOS_VERSION = "2.3.1";
    ZANEYOS = "true";
  };
  console.keyMap = "${consoleKeyMap}";
  system.stateVersion = "25.05"; # Do not change!
}
