{
  inputs,
  lib,
  ...
}:
{
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
    };
    portal = {
      enable = lib.mkForce true;
      extraPortals = [ inputs.hyprland.packages.x86_64-linux.xdg-desktop-portal-hyprland ];
      configPackages = [ inputs.hyprland.packages.x86_64-linux.hyprland ];
    };
  };
}
