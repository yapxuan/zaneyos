{ pkgs, ... }:
{
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    settings = {
      General.DisplayServer = "wayland";
      Theme = {
        Current = "sddm-astronaut-theme";
      };
    };
  };
  environment.systemPackages = [
    pkgs.kdePackages.qtmultimedia
    (pkgs.sddm-astronaut.override {
      embeddedTheme = "hyprland_kath";
    })
  ];
}
