{ pkgs, ... }:
{
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty;
    settings = {
      theme = "Dracula";
      font-size = 12;
      adjust-cell-height = "10%";
      window-theme = "dark";
      window-height = 32;
      window-width = 110;
      background-opacity = 0.95;
      background-blur-radius = 60;
      selection-background = "\#2d3f76";
      selection-foreground = "\#c8d3f5";
      cursor-style = "bar";
      mouse-hide-while-typing = "true";
      #copy-on-select = "clipboard";
      font-family = "BerkeleyMono Nerd Font";
      title = "GhosTTY";
      wait-after-command = false;
      shell-integration = "detect";
      window-save-state = "always";
      gtk-single-instance = true;
      unfocused-split-opacity = 0.5;
      quick-terminal-position = "center";
      shell-integration-features = "cursor,sudo";
    };
  };
}
