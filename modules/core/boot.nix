{
  pkgs,
  config,
  ...
}:
{
  boot = {
    kernelPackages = pkgs.linuxPackages_cachyos.cachyOverride {
      mArch = "ZEN4";
      useLTO = "full";
    };

    kernelParams = [
      "systemd.swap=0"
    ];

    kernelModules = [
      "v4l2loopback"
      "kvm-amd"
    ];

    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
    kernel.sysctl = {
      "vm.max_map_count" = 2147483642;
      "kernel.sysrq" = 1; # REISUB
    };

    extraModprobeConfig = ''
      options mt7921_common disable_clc=1
    '';

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "thunderbolt"
        "uas"
        "sd_mod"
      ];
    };

    loader.limine = {
      enable = true;
      efiSupport = true;
      maxGenerations = 10;
      style.wallpapers = [ pkgs.nixos-artwork.wallpapers.simple-dark-gray-bootloader.gnomeFilePath ];
      extraEntries = ''
        /Windows
            protocol: efi
            path: guid(d3a7820d-fcf3-4ad3-9468-d6481e4aee50):/EFI/Microsoft/Boot/bootmgfw.efi
      '';
    };

    loader.efi.canTouchEfiVariables = true;
    plymouth.enable = true;
  };
}
