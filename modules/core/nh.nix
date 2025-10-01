{
  flake_dir,
  ...
}:
{
  programs.nh = {
    enable = true;
    clean = {
      enable = true;
      extraArgs = "--optimise";
    };
    flake = "${flake_dir}";
  };
}
