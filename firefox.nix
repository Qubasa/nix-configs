{ config, pkgs, ... }:

let
  # Firefox addons
  https-everywhere = pkgs.callPackage ./own-pkgs/https-everywhere {};
  ublock-origin = pkgs.callPackage ./own-pkgs/ublock-origin {};
  user-agent-switcher = pkgs.callPackage ./own-pkgs/user-agent-switcher {};
  dark-reader = pkgs.callPackage ./own-pkgs/dark-reader {};
  tree_style_tabs = pkgs.callPackage ./own-pkgs/tree-tab {};

#  userjs-hardened = pkgs.callPackage ./own-pkgs/userjs-hardenend {};

  wrapper = pkgs.callPackage ./overlays/firefox-with-config.nix {};
    hardenedFirefox= wrapper pkgs.unstable.firefox-unwrapped {

    extraExtensions = [
      ublock-origin
      dark-reader
    ];

    extraPolicies = {
    CaptivePortal = false;
    };

    noNewProfileOnFFUpdate = true;
    clearDataOnShutdown = false;
    disableDrmPlugin = true;
    enableDarkDevTools = true;
    disablePocket = true;
    disableFirefoxSync = true;
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
