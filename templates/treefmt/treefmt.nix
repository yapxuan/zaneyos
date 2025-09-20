{
  projectRootFile = "flake.nix";
  programs = {
    alejandra = {
      enable = true;
      priority = 0;
    };
    nixfmt = {
      enable = true;
      priority = 1;
    };
  };
}
