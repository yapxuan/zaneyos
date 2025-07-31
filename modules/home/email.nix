{
  # 启用邮件相关程序
  programs = {
    msmtp.enable = true;
    mbsync = {
      enable = true;
      extraConfig = ''
        IMAPAccount gmail
        Host imap.gmail.com
        User puiyongqing@gmail.com
        PassCmd "secret-tool lookup aerc-account gmail username puiyongqing@gmail.com"
        TLSType IMAPS
        AuthMechs LOGIN
        CertificateFile /etc/ssl/certs/ca-certificates.crt

        IMAPStore gmail-remote
        Account gmail

        MaildirStore gmail-local
        Path ~/.mail/gmail/
        Inbox ~/.mail/gmail/INBOX
        SubFolders Verbatim

        Channel gmail
        Far :gmail-remote:
        Near :gmail-local:
        Patterns *
        Create Near
        Sync All
        Expunge Both
        CopyArrivalDate yes
      '';
    };
    aerc.enable = true;
    git.extraConfig.sendemail = {
      smtpserver = "/run/current-system/sw/bin/msmtp";
      suppresscc = "all";
      confirm = "auto";
    };
  };

  # 邮件账户配置
  accounts.email.accounts = {

    gmail = {
      primary = true;
      realName = "Pui Yong Qing";
      address = "puiyongqing@gmail.com";
      userName = "puiyongqing@gmail.com";
      flavor = "gmail.com";

      # 使用 GNOME Keyring 储存 App Password（执行 secret-tool）
      passwordCommand = "secret-tool lookup aerc-account gmail username puiyongqing@gmail.com";

      # Maildir 本地路径，用于与 mbsync 同步邮件
      maildir = {
        enable = true;
        path = ".mail/gmail"; # 将生成 ~/.mail/gmail 目录
      };

      # IMAP 服务器（收件）
      imap = {
        host = "imap.gmail.com";
        port = 993;
        tls.enable = true;
      };

      # SMTP 服务器（发件）
      smtp = {
        host = "smtp.gmail.com";
        port = 587;
        tls = {
          enable = true;
          useStartTls = true;
        };
      };

      # MSMTP
      msmtp = {
        enable = true;
        extraConfig = {
          tls_starttls = "on";
          tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
          logfile = "~/.msmtp.log";
        };
      };
    };
  };
}
