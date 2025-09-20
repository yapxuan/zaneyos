{ pkgs, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics = {
      enable = true;
      enable32Bit = true;
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
    };
  };
  chaotic.mesa-git = {
    enable = true;
    fallbackSpecialisation = false;
    extraPackages = with pkgs.mesa_git; [
      opencl
    ];
    extraPackages32 = with pkgs.mesa32_git; [
      opencl
    ];
  };
  local.hardware-clock.enable = false;
}
