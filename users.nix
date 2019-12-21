{ config, pkgs, ... }:
{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.${config.mainUser} = {
    name = config.mainUser;
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "wireshark" "dialout"];
  };

}
