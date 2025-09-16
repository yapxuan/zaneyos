{ pkgs, ... }:
{
  programs.uv = {
    enable = true;
    package = pkgs.uv;
    settings = { };
  };
}
