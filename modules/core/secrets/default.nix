# import & decrypt secrets in `mysecrets` in this module
{
  pkgs,
  inputs,
  ...
}:
let
  agenix = inputs.agenix;
  mysecrets = inputs.mysecrets;
in
{
  imports = [
    agenix.nixosModules.default
  ];
  age.ageBin = "${pkgs.rage}/bin/rage";
  # if you changed this key, you need to regenerate all encrypt files from the decrypt contents!
  age.identityPaths = [
    # using the host key for decryption
    # the host key is generated on every host locally by openssh, and will never leave the host.
    "/etc/ssh/ssh_host_ed25519_key"
  ];

  age.secrets = {
    "primary-key" = {
      # whether secrets are symlinked to age.secrets.<name>.path
      symlink = true;
      # encrypted file path
      file = "${mysecrets}/puiyq-primary-key.priv.age"; # refer to ./xxx.age located in `mysecrets` repo
      mode = "0400";
      owner = "root";
      group = "root";
    };
    "gpg-subkeys" = {
      symlink = true;
      file = "${mysecrets}/puiyq-gpg-subkeys.priv.age";
      mode = "0400";
      owner = "root";
      group = "root";
    };
    "revoke-cert" = {
      symlink = true;
      file = "${mysecrets}/revoke.asc.age";
      mode = "0400";
      owner = "root";
      group = "root";
    };
  };
}
