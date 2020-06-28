{ config, pkgs, ... }:

let

  wrapper = pkgs.callPackage ./overlays/wrapper.nix { fx_cast_bridge=pkgs.unstable.pkgs.fx_cast_bridge; };

  hardenedFirefox= wrapper pkgs.firefox-unwrapped {
    extraExtensions = [
      {
        name = "ublock";
        url = "https://addons.mozilla.org/firefox/downloads/file/3452970/ublock_origin-1.24.2-an+fx.xpi";
        sha256 = "0kjjwi91ri958gsj4l2j3xqwj4jgkcj4mlqahqd1rz9z886sd9dy";
      }
      {
        name = "https-everywhere";
        url = "https://addons.mozilla.org/firefox/downloads/file/3574076/https_everywhere-2020.5.20-an+fx.xpi?src=search";
        sha256 = "10wjimk9wrdfja6f73pppm7pmb1jl838p7siwh4vzlw1sjszr57c";
      }
    ];

    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
    };

    extraPrefs = ''
      // Show more ssl cert infos
      lockPref("security.identityblock.show_extended_validation", true);

      // Enable userchrome css
      lockPref("toolkit.legacyUserProfileCustomizations.stylesheets", true);

      // Enable dark dev tools
      lockPref("devtools.theme","dark");
    '';

    gdkWayland = true;
  };

in {

environment.variables = {
  BROWSER = ["firefox"];
};

environment.systemPackages = with pkgs; [
  hardenedFirefox
];

}
