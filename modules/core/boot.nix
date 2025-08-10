{ pkgs, config, ... }:

{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos-rc.cachyOverride { mArch = "ZEN4"; };

    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
    };
    loader.limine = {
      enable = true;
      efiSupport = true;
      style.wallpapers = [ pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath ];
      extraEntries = ''
        /Windows
            protocol: efi
            path: guid(d3a7820d-fcf3-4ad3-9468-d6481e4aee50):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };
    loader.efi.canTouchEfiVariables = true;
    # Appimage Support
    binfmt.registrations.appimage = {
      wrapInterpreterInShell = false;
      interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      recognitionType = "magic";
      offset = 0;
      mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      magicOrExtension = ''\x7fELF....AI\x02'';
    };
    plymouth.enable = true;
  };
}
