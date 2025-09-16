{
  pkgs,
  inputs,
  lib,
  #pkgs-stable,
  ...
}:
{
  programs = {
    #partition-manager.enable = true;
    #appimage = {
    # enable = true;
    # binfmt = true;
    # package = pkgs.appimage-run.override {
    #   extraPkgs = pkgs: [
    #     pkgs.ffmpeg
    #     pkgs.imagemagick
    #   ];
    # };
    #};
    zsh.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
    };
    firefox.enable = true; # Firefox is not installed by default
    dconf.enable = true;
    seahorse.enable = true;
    hyprland = {
      enable = true; # create desktop file and depedencies if you switch to GUI login MGR
      package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
      portalPackage =
        inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
    };
    hyprlock.enable = true; # resolve pam issue https://gitlab.com/Zaney/zaneyos/-/issues/164
    fuse.userAllowOther = true;
    mtr.enable = true;
    #adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs = {
    config = {
      rocmSupport = true;
      allowUnfree = true;
    };
  };

  environment = {
    sessionVariables = {
      MOZ_USE_XINPUT2 = "1";
    };
    variables = {
      HSA_OVERRIDE_GFX_VERSION = "11.0.0";
      PATH = lib.mkAfter "/opt/rocm/bin";
      LD_LIBRARY_PATH = lib.mkAfter "/opt/rocm/lib";
    };
  };

  environment.systemPackages = with pkgs; [
    inputs.self.packages.${system}.animeko
    #pkgs-stable.animeko
    discord
    xarchiver
    teams-for-linux
    #blender-hip
    rage
    nix-ld
    (pkgs.bilibili.override {
      commandLineArgs = "--ozone-platform-hint=wayland --enable-wayland-ime --enable-features=UseOzonePlatform";
    })
    cryptsetup
    adwaita-icon-theme
    libsecret
    #nur.repos.ataraxiasjel.waydroid-script
    #waydroid-helper
    onlyoffice-desktopeditors
    varia
    #winetricks
    #wineWowPackages.stagingFull
    openssl
    element-desktop
    bottom # btop like util
    brightnessctl # For Screen Brightness Control
    cargo
    clang
    clippy
    curlie
    duf # Utility For Viewing Disk Usage In Terminal
    dysk # disk usage util
    eza # Beautiful ls Replacement
    fd
    ffmpeg # Terminal Video / Audio Editing
    gdu # graphical disk usage
    glow
    tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    loupe # For Image Viewing
    jq
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    mpv # Incredible Video Player
    nixfmt # Nix Formatter
    nix-output-monitor
    nixpkgs-review
    nixd
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    ripgrep # Improved Grep
    rustc
    rustfmt
    rust-analyzer
    socat # Needed For Screenshots
    sox # audio support for FFMPEG
    inputs.swww.packages.${pkgs.system}.swww
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    usbutils # Good Tools For USB Devices
    # v4l-utils # Used For Things Like OBS Virtual Camera
    # waypaper # backup wallpaper GUI
    wget # Tool For Fetching Files With Links
    zapzap # Alternative of Whatsapp
    (prismlauncher.override {
      # Add binary required by some mod
      additionalPrograms = [ ffmpeg ];

      # Change Java runtimes available to Prism Launcher
      jdks = [
        graalvm-ce
        zulu8
        zulu17
        zulu
      ];
    })
  ];
}
