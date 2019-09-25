{ config, pkgs, ... }:

 {
  imports =
  [ # Include the results of the hardware scan.
    ./modules/krebs-tinc.nix
  ];

  networking.retiolum.ipv4 = "10.243.29.175";
  networking.retiolum.nodename = "qubasa";
  networking.retiolum.privKeyFile = "${config.secrets}/vpn/krebs-tinc/qubasa.rsa_key.priv";

}
