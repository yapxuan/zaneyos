{ config }:
{
  chaotic.duckdns = {
    enable = true;
    domain = "puiyq.duckdns.org";
    onCalendar = "hourly";
  };
  environment = {
    etc = {
      "duckdns-updater/envs" = {
        source = config.age.secrets.duckdns.path;
        mode = "0600";
      };
    };
  };
}
