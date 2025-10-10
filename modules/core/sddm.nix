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
}
