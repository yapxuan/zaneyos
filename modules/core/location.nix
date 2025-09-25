{
  # enable location service
  location.provider = "geoclue2";

  # provide location
  services.geoclue2 = {
    enable = true;
    enable3G = false;
    enableModemGPS = false;
    enableNmea = false;
    enableCDMA = false;
    geoProviderUrl = "https://beacondb.net/v1/geolocate";
    submissionUrl = "https://beacondb.net/v2/geosubmit";
    submissionNick = "geoclue";

    appConfig.trippy = {
      isAllowed = true;
      isSystem = false;
    };
  };
}
