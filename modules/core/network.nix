{
  pkgs,
  host,
  options,
  ...
}:
{
  networking = {
    hostName = "${host}";
    networkmanager.enable = true;
    timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
    firewall = {
      enable = true;
      allowedTCPPorts = [ 587 ];
      allowedUDPPorts = [ ];
    };
  };

  environment.systemPackages = with pkgs; [ networkmanagerapplet ];
}
