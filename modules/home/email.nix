{
  programs = {
    thunderbird = {
      enable = true;
      profiles = { };
    };
  };

  accounts.email.accounts = {

    outlook = {
      realName = "Yong Qing PUI";
      address = "104395234@students.swinburne.edu.my";
      thunderbird.enable = true;
    };

    gmail = {
      primary = true;
      realName = "Pui Yong Qing";
      address = "puiyongqing@gmail.com";
      thunderbird.enable = true;
    };
  };
}
