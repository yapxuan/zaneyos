{
  pkgs,
  #pkgs-master,
  inputs,
  ...
}:
{
  programs = {
    partition-manager.enable = true;
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
    adb.enable = true;
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
    overlays = [
      (import ../../overlay)
    ];
  };
  nix.package = pkgs.nixVersions.git;

  environment.systemPackages = with pkgs; [
    cryptsetup
    btrfs-assistant
    #inputs.quickemu.packages.${pkgs.system}.quickemu # waiting for staging merge
    adwaita-icon-theme
    ntfs3g
    libsecret
    sbctl
    #nur.repos.ataraxiasjel.waydroid-script
    #waydroid-helper
    onlyoffice-desktopeditors
    varia
    winetricks
    wineWowPackages.stagingFull
    gnome-software
    openssl
    element-desktop
    # amfora # Fancy Terminal Browser For Gemini Protocol
    appimage-run # Needed For AppImage Support
    bottom # btop like util
    # brave # Brave Browser
    brightnessctl # For Screen Brightness Control
    cargo
    clang
    clippy
    # cmatrix # Matrix Movie Effect In Terminal
    # cowsay # Great Fun Terminal Program
    curlie
    docker-compose # Allows Controlling Docker From A Single File
    duf # Utility For Viewing Disk Usage In Terminal
    dysk # disk usage util
    eza # Beautiful ls Replacement
    fd
    ffmpeg # Terminal Video / Audio Editing
    # file-roller # Archive Manager
    gdu # graphical disk usage
    # gedit # Simple Graphical Text Editor
    # gimp # Great Photo Editor
    glow
    glxinfo # Needed for inxi -G GPU info
    # gping # graphical ping
    tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    # htop # Simple Terminal Based System Monitor
    hyprpicker # Color Picker
    loupe # For Image Viewing
    # inxi # CLI System Information Tool
    jq
    killall # For Killing All Instances Of Programs
    libnotify # For Notifications
    lm_sensors # Used For Getting Hardware Temps
    # lolcat # Add Colors To Your Terminal Command Output
    # lshw # Detailed Hardware Information
    mpv # Incredible Video Player
    # ncdu # Disk Usage Analyzer With Ncurses Interface
    # nitch # small fetch util
    nixfmt # Nix Formatter
    nix-output-monitor
    nixpkgs-review
    # nil
    nixd
    nvd
    # onefetch # shows current build info and stats
    pavucontrol # For Editing Audio Levels & Devices
    pciutils # Collection Of Tools For Inspecting PCI Devices
    # picard # For Changing Music Metadata & Getting Cover Art
    # pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    playerctl # Allows Changing Media Volume Through Scripts
    python3Full
    # qbittorrent
    # rhythmbox
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
    # ytmdl # Tool For Downloading Audio From YouTube
    zapzap # Alternative of Whatsapp
    animeko
    # inputs.helix.packages."${pkgs.system}".helix
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
