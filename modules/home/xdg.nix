{ inputs, ... }:
{
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;
    };
    portal = {
      enable = true;
      extraPortals = [ inputs.hyprland.packages.x86_64-linux.xdg-desktop-portal-hyprland ];
      configPackages = [ inputs.hyprland.packages.x86_64-linux.hyprland ];
    };
  };
}
