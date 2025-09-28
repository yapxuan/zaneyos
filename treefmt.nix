{
  projectRootFile = "flake.nix";
  programs = {
    nixfmt.enable = true;
    zig.enable = true;
    gofmt.enable = true;
    clang-format.enable = true;
    taplo.enable = true;
    rustfmt.enable = true;
  };
}
