{ config, pkgs, ... }:

{

  # Symlink the opensc path
  # nixpkgs.config.packageOverrides = super: {
  #   openvpn = super.openvpn.override { pkcs11Support = true; useSystemd = false;};
  #   opensc = super.opensc.overrideAttrs (old: {
  #     version = "0.17.0";
  #     name = "opensc-0.17.0";
  #     src = pkgs.fetchFromGitHub {
  #       owner = "OpenSC";
  #       repo = "OpenSC";
  #       rev = "0.17.0";
  #       sha256 = "1mgcf698zhpqzamd52547scdws7mhdva377kc3chpr455n0mw8g0";
  #     };
  #   });
  # };

  #environment.systemPackages = with pkgs; [
  #  opensc
  #  openvpn
  #  yubikey-manager
  #];


  # Executed after awaking. Restarts openvpn services
  systemd.services.restart_ovpn = {
    description = "Restart OpenVPN after suspend";
    wantedBy = [ "suspend.target" ];
    after = [ "suspend.target" ];
    serviceConfig = {
      ExecStart = "${pkgs.procps}/bin/pkill --signal SIGHUP --exact openvpn
";
      Type = "oneshot";
    };
  };


  # services.pcscd.enable = true;
  

  # for thunderbird yubikey support
  #environment.etc."opensc" = {
  #  source = "${pkgs.opensc}";
  #};

  # To start the vpn manually execute
  # $ openvpn --config clien.ovpn
}
