{
  pkgs,
  inputs,
  ...
}:
{
  xdg.portal = {
    enable = true;
    extraPortals = [
      inputs.hyprland.packages.x86_64-linux.xdg-desktop-portal-hyprland
    ];
    configPackages = [
      inputs.hyprland.packages.x86_64-linux.hyprland
    ];
  };
  services = {
    flatpak.enable = true; # Enable Flatpak
  };
  systemd.services.flatpak-repo = {
    wantedBy = [ "multi-user.target" ];
    path = [ pkgs.flatpak ];
    script = ''
      flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
    '';
  };
}
