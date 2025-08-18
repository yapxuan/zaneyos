{ host, pkgs, ... }:
let
  inherit (import ../../hosts/${host}/variables.nix) gitUsername gitEmail;
in
{
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName = "${gitUsername}";
    userEmail = "${gitEmail}";
    ignores = [
      ".envrc"
      ".direnv"
      "result"
      ".Trash-1000"
    ];

    delta = {
      enable = true;
      options = {
        line-numbers = true;
        navigate = true;
        hyperlinks = true;
      };
    };

    extraConfig = {
      credential.helper = "libsecret";
      # FOSS-friendly settings
      push.default = "simple"; # Match modern push behavior
      init.defaultBranch = "main"; # Set default new branches to 'main'
      log.decorate = "full"; # Show branch/tag info in git log
      log.date = "iso"; # ISO 8601 date format
      # Conflict resolution style for readable diffs
      merge.conflictStyle = "diff3";
      diff.colorMoved = "default";
      sendemail = {
        smtpserver = "smtp.gmail.com";
        smtpserverport = "587";
        smtpencryption = "tls";
        smtpuser = "puiyongqing@gmail.com";
        smtppass.suppresscc = "all"; # don't automatically cc anyone (for testing)
      };
    };
    # Optional: FOSS-friendly Git aliases
    aliases = {
      br = "branch --sort=-committerdate";
      co = "checkout";
      df = "diff";
      com = "commit -a";
      gs = "stash";
      gp = "pull";
      lg = "log --graph --pretty=format:'%Cred%h%Creset - %C(yellow)%d%Creset %s %C(green)(%cr)%C(bold blue) <%an>%Creset' --abbrev-commit";
      st = "status";
    };
  };
}
