{ pkgs, ... }:
{
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [

      ##############
      # Core system
      ##############
      stdenv.cc.cc # C/C++ runtime
      glib # Core GNOME/GTK runtime
      libgcc.lib
      zlib
      zstd
      bzip2
      xz
      openjdk17
      libarchive
      openssl
      libsodium
      attr
      acl
      libcap
      util-linux
      coreutils
      curl
      icu
      expat
      libelf
      libxcrypt
      # libxcrypt-legacy      # Legacy apps (e.g. Natron) – enable only if needed

      ##################
      # X11 / graphics
      ##################
      xorg.libX11
      xorg.libXext
      xorg.libXfixes
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXrandr
      xorg.libXi
      xorg.libXinerama
      xorg.libXcursor
      xorg.libXrender
      xorg.libXScrnSaver
      #xorg.libSM
      #xorg.libICE
      xorg.libXt
      xorg.libXmu
      xorg.libxshmfence
      xorg.libXxf86vm

      libGL
      libglvnd
      #libGLU # Needed by some X11 OpenGL apps
      libgbm
      libdrm
      #libvdpau
      vulkan-loader
      #pixman

      ##################
      # Wayland / media
      ##################
      #pipewire
      libva
      ffmpeg
      alsa-lib

      ##################
      # GTK / GNOME / desktop
      ##################
      #gtk2
      gtk3
      pango
      cairo
      atk
      gdk-pixbuf
      fontconfig
      freetype
      libnotify
      gsettings-desktop-schemas
      dbus
      dbus-glib
      zenity
      #gnome2.GConf
      #nspr
      #nss
      #libcanberra
      #libindicator-gtk2
      #libappindicator-gtk2
      #libdbusmenu-gtk2

      ##################
      # SDL / games / multimedia
      ##################
      #SDL
      SDL2
      #SDL_image
      SDL2_image
      #SDL_ttf
      SDL2_ttf
      #SDL_mixer
      SDL2_mixer
      libogg
      libvorbis
      flac
      libsamplerate
      #libmikmod
      #libtheora
      libvpx
      libjpeg
      libpng
      libpng12
      libtiff
      #libglew110

      ##################
      # System / utilities / hardware
      ##################
      networkmanager
      libusb1
      libudev0-shim
      fuse
      btrfs-progs
      pciutils
      #xorg.libXkbcommon # For Blender and keyboard support

      ##################
      # Optional / legacy / rarely used (commented out)
      ##################
      # glibc_multi.bin       # Usually not needed, may cause issues on ARM
      # libtheora             # For very old media apps
      # libmikmod             # For very old game music formats
      # cups                  # Printing support
      # libxcrypt-legacy      # Legacy X apps (Natron)
      # nspr, nss             # Needed by Firefox/Chrome / TLS apps
    ];
  };
}
