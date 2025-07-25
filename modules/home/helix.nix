{ pkgs, ... }:
{
  # helix configuration
  programs.helix = {
    enable = true;
    settings = {
      # theme = "autumn_night_transparent";
      editor.cursor-shape = {
        normal = "block";
        insert = "bar";
        select = "underline";
      };
    };
    languages = {
      language = [
        {
          name = "nix";
          auto-format = true;
          formatter.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
        }
        {
          name = "rust";
          auto-format = true;
          formatter.command = "rustfmt";
          #language-servers = [
          #  {
          #    name = "rust-analyzer";
          #    command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
          #    args = ["--enable-clippy"];
          #  }
          #];
        }
      ];
      language-server.rust-analyzer = {
        command = "${pkgs.rust-analyzer}/bin/rust-analyzer";
        args = [ "--enable-clippy" ];
      };
    };
  };
}
