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
      background-blur = 60;
      selection-background = "\#2d3f76";
      selection-foreground = "\#c8d3f5";
      cursor-style = "bar";
      mouse-hide-while-typing = "true";
      #copy-on-select = "clipboard";
      font-family = "BerkeleyMono Nerd Font";
      title = "GhosTTY";
      wait-after-command = false;
      confirm-close-surface = false;
      shell-integration = "detect";
      window-save-state = "always";
      gtk-single-instance = true;
      unfocused-split-opacity = 0.5;
      quick-terminal-position = "top";
      quick-terminal-size = "110px,30px";
      quit-after-last-window-closed = true;
      quit-after-last-window-closed-delay = "5m";
      shell-integration-features = "cursor,sudo,ssh-env,ssh-terminfo";
      keybind = [
        "global:super+t=toggle_quick_terminal"
      ];
    };
  };
  systemd.user.services."app-com.mitchellh.ghostty" = {
    Unit = {
      Description = "Ghostty background daemon";
      After = [
        "graphical-session.target"
        "dbus.socket"
      ];
      Requires = [ "dbus.socket" ];
    };
    Service = {
      Type = "notify-reload";
      ReloadSignal = "SIGUSR2";
      BusName = "com.mitchellh.ghostty";
      ExecStart = "${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false";
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
