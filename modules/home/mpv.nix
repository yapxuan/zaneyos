{
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    config = {
      hwdec = "auto";
    };
  };
}
