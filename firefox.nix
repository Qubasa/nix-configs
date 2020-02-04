{ config, pkgs, ... }:

let

  unstable = import <nixos-unstable> { };
  # Firefox addons
  https-everywhere = pkgs.callPackage ./own-pkgs/https-everywhere {};
  ublock-origin = pkgs.callPackage ./own-pkgs/ublock-origin {};
  webgl-fingerprint-defender = pkgs.callPackage ./own-pkgs/webgl-fingerprint-defender {};
  canvas-fingerprint-defender = pkgs.callPackage ./own-pkgs/canvas-fingerprint-defender {};
  audio-fingerprint-defender = pkgs.callPackage ./own-pkgs/audio-fingerprint-defender {};
  font-fingerprint-defender = pkgs.callPackage ./own-pkgs/font-fingerprint-defender {};
  user-agent-switcher = pkgs.callPackage ./own-pkgs/user-agent-switcher {};
  dark-reader = pkgs.callPackage ./own-pkgs/dark-reader {};
  tree_style_tabs = pkgs.callPackage ./own-pkgs/tree-tab {};

  wrapper = pkgs.callPackage ./overlays/firefox-with-config.nix { };
  myFirefox = wrapper unstable.firefox-unwrapped {
  browserName = "firefox";

  extraExtensions = [
    ublock-origin
    dark-reader
    tree_style_tabs
  ];

  extraPolicies = {
    CaptivePortal = false;
  };

    disablePocket = true;
    enableUserchromeCSS = true;
    disableFirefoxSync = true;
    allowNonSigned = true;
    noNewProfileOnFFUpdate = true;
    clearDataOnShutdown = true;
    disableDrmPlugin = false;
    enableDarkDevTools = true;
    # blockMixedSSLPage = true;

 #   Newline on copy problem: https://bugzilla.mozilla.org/show_bug.cgi?id=1547595
    gdkWayland = true;

};

in {


environment.variables = {
  BROWSER = ["firefox"];
};


environment.systemPackages = with pkgs; [
  myFirefox
];

}
