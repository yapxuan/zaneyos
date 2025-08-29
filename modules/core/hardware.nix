{ pkgs, rocm64, ... }:
{
  hardware = {
    enableRedistributableFirmware = true;
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;
    graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        rocm64.rocmPackages.clr.icd
      ];
    };
    amdgpu = {
      initrd.enable = true;
      opencl.enable = true;
      amdvlk = {
        enable = true;
        support32Bit.enable = true;
        supportExperimental.enable = true;
      };
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
