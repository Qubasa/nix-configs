{ config, pkgs, ... }:

let
  # Firefox addons
  https-everywhere = pkgs.callPackage ./own-pkgs/https-everywhere {};
  ublock-origin = pkgs.callPackage ./own-pkgs/ublock-origin {};
  user-agent-switcher = pkgs.callPackage ./own-pkgs/user-agent-switcher {};
  dark-reader = pkgs.callPackage ./own-pkgs/dark-reader {};
  tree_style_tabs = pkgs.callPackage ./own-pkgs/tree-tab {};

#  userjs-hardened = pkgs.callPackage ./own-pkgs/userjs-hardenend {};

  # wrapper = pkgs.callPackage ./overlays/firefox-with-config.nix { fx_cast_bridge=pkgs.unstable.pkgs.fx_cast_bridge; };
  wrapper = pkgs.callPackage ./overlays/wrapper.nix { fx_cast_bridge=pkgs.unstable.pkgs.fx_cast_bridge; };

  hardenedFirefox= wrapper pkgs.firefox-unwrapped {
    extraExtensions = [
      {
        extid = "uBlock0@raymondhill.net";
        name = "ublock";
        url = "https://addons.mozilla.org/firefox/downloads/file/3452970/ublock_origin-1.24.2-an+fx.xpi";
        sha256 = "0kjjwi91ri958gsj4l2j3xqwj4jgkcj4mlqahqd1rz9z886sd9dy";
      }
    ];

    # extraExtensions = [
    #   ublock-origin
    #   dark-reader
    # ];

    # extraPolicies = {
    # CaptivePortal = false;
    # };

    # noNewProfileOnFFUpdate = true;
    # clearDataOnShutdown = false;
    # disableDrmPlugin = false;
    # enableDarkDevTools = true;
    # disablePocket = true;
    # disableFirefoxSync = true;
  #   extraPrefs = builtins.readFile "${userjs-hardened}/firefox-profile/user.js";

  #   Newline on copy problem: https://bugzilla.mozilla.org/show_bug.cgi?id=1547595
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
