{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
      qtpass
      pinentry-gnome
      pinentry
     (pass.withExtensions (ext: [
          ext.pass-otp
        ]))
    ];
}
