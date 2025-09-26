{
  inputs,
  pkgs,
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
      extraPortals = [ inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland ];
      configPackages = [ inputs.hyprland.packages.${pkgs.system}.hyprland ];
    };
  };
}
