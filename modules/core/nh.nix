{
  pkgs,
  username,
  inputs,
  ...
}:
{
  programs.nh = {
    enable = true;
    package = inputs.nh.packages."${pkgs.system}".nh;
    clean = {
      enable = true;
      extraArgs = "--optimise";
    };
    flake = "/home/${username}/zaneyos";
  };
}
