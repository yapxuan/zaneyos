{ pkgs, config, ... }:
{
  programs.msmtp = {
    enable = true;
    setSendmail = true; # Sets msmtp as system sendmail

    defaults = {
      auth = true;
      tls = true;
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      logfile = "/var/log/msmtp.log";
    };

    accounts = {
      gmail = {
        host = "smtp.gmail.com";
        port = 587;
        from = "puiyongqing@gmail.com";
        user = "puiyongqing@gmail.com";
        passwordeval = "${pkgs.coreutils-full}/bin/cat ${config.age.secrets.gmail_app_password.path}";
      };
      default = {
        # Makes gmail the default account
        host = "smtp.gmail.com";
        port = 587;
        from = "puiyongqing@gmail.com";
        user = "puiyongqing@gmail.com";
        passwordeval = "${pkgs.coreutils-full}/bin/cat ${config.age.secrets.gmail_app_password.path}";
      };
    };
  };
}
