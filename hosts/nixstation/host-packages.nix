{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    audacity
    discord
    nodejs
    handbrake
    yt-dlp
    android-studio
    android-studio-tools
    android-tools
  ];
}
