{ config, pkgs, ... }:
{

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.${config.mainUser} = rec {
    name = config.mainUser;
    initialPassword = name;
    isNormalUser = true;
    uid = 1000;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "input" "wireshark" "dialout"];
  };


}
