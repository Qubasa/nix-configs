{ config, pkgs, ... }:

let

  # Firefox addons
  https-everywhere = pkgs.callPackage ./own-pkgs/https-everywhere {};
  ublock-origin = pkgs.callPackage ./own-pkgs/ublock-origin {};
  webgl-fingerprint-defender = pkgs.callPackage ./own-pkgs/webgl-fingerprint-defender {};
  canvas-fingerprint-defender = pkgs.callPackage ./own-pkgs/canvas-fingerprint-defender {};
  audio-fingerprint-defender = pkgs.callPackage ./own-pkgs/audio-fingerprint-defender {};
  font-fingerprint-defender = pkgs.callPackage ./own-pkgs/font-fingerprint-defender {};

  wrapper = pkgs.callPackage ./overlays/firefox-with-config.nix { };
  myFirefox = wrapper pkgs.firefox-unwrapped {

  extraExtensions = [
    https-everywhere
    ublock-origin
    audio-fingerprint-defender
    canvas-fingerprint-defender
    webgl-fingerprint-defender
    font-fingerprint-defender
  ];

  extraPolicies = {
    CaptivePortal = false;
  };

    disablePocket = true;
    disableFirefoxSync = true;
    allowNonSigned = true;
    clearDataOnShutdown = true;
    disableDrmPlugin = true;

    gdkWayland = true;

};

in {


environment.variables = {
  BROWSER = ["firefox"];
};

programs.firejail = {
  enable = true;
  wrappedBinaries = {
    firefox = "${myFirefox}/bin/firefox";
  };
};
}
