{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
      qtpass
     (pass.withExtensions (ext: [
          ext.pass-otp
        ]))
    ];
}
