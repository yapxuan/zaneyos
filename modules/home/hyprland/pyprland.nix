{ pkgs, ... }:
{
  home.packages = with pkgs; [ pyprland ];

  home.file.".config/hypr/pyprland.toml".text = ''
    [pyprland]
    plugins = [
      "scratchpads",
    ]

    [scratchpads.term]
    animation = "fromTop"
    command = "ghostty --class=com.mitchellh.ghostty-dropterm"
    class = "com.mitchellh.ghostty-dropterm"
    size = "82% 80%"
    max_size = "1920px 100%"
  '';
}
