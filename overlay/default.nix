{ firmware, ... }:
{
  nixpkgs.overlays = [
    (_final: prev: {

      qt6Packages = prev.qt6Packages.overrideScope (
        _final': prev': {
          # HACK: no more qt5
          fcitx5-with-addons = prev'.fcitx5-with-addons.override { libsForQt5.fcitx5-qt = null; };

          # HACK: no more kde stuff
          fcitx5-configtool = prev'.fcitx5-configtool.override { kcmSupport = false; };

          # HACK: no more qtwebengine, opencc
          fcitx5-chinese-addons =
            (prev'.fcitx5-chinese-addons.override {
              curl = null;
              opencc = null;
              qtwebengine = null;
            }).overrideAttrs
              (oldAttrs: {
                buildInputs = oldAttrs.buildInputs ++ [
                  prev.gettext
                  prev'.qtbase
                ];
                cmakeFlags = oldAttrs.cmakeFlags ++ [
                  (prev.lib.cmakeBool "ENABLE_BROWSER" false)
                  (prev.lib.cmakeBool "ENABLE_CLOUDPINYIN" false)
                  (prev.lib.cmakeBool "ENABLE_OPENCC" false)
                ];
              });
        }
      );

      # HACK: no more gtk2
      gnome-themes-extra = (prev.gnome-themes-extra.override { gtk2 = null; }).overrideAttrs {
        configureFlags = [ "--disable-gtk2-engine" ];
      };

      # HACK:
      xdg-desktop-portal-gtk =
        (prev.xdg-desktop-portal-gtk.override {
          gnome-settings-daemon = null;
          gnome-desktop = null;
          gsettings-desktop-schemas = null;
        }).overrideAttrs
          {
            mesonFlags = [ (prev.lib.mesonEnable "wallpaper" false) ];
          };

      inherit (firmware) linux-firmware; # FIXME
      /*
        mt7921e wifi firmware broken with linux-firmware 20250918
        Related issue: https://gitlab.archlinux.org/archlinux/packaging/packages/linux-firmware/-/issues/29
        Posible upstream related commit: https://gitlab.com/kernel-firmware/linux-firmware/-/commit/4573c02ca0caf001c5ce5dbb62015d588258588b
      */

    })
  ];
}
