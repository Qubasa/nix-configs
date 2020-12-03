{ config, pkgs, ... }:

let
  fetchfirefoxaddon=callPackage ./modules/fetchfirefoxaddon {};
  callPackage = pkgs.lib.callPackageWith (pkgs);
  wrapper = pkgs.callPackage ./overlays/wrapper.nix { fx_cast_bridge=pkgs.unstable.pkgs.fx_cast_bridge; };

  hardenedFirefox= wrapper pkgs.firefox-unwrapped {
    # extraExtensions = [
    #   (fetchfirefoxaddon {
    #     name = "ublock";
    #     url = "https://addons.mozilla.org/firefox/downloads/file/3679754/ublock_origin-1.31.0-an+fx.xpi";
    #     sha256 = "1h768ljlh3pi23l27qp961v1hd0nbj2vasgy11bmcrlqp40zgvnr";
    #   })
    #   (fetchfirefoxaddon {
    #      name = "https-everywhere";
    #      url = "https://addons.mozilla.org/firefox/downloads/file/3574076/https_everywhere-2020.5.20-an+fx.xpi?src=search";
    #      sha256 = "10wjimk9wrdfja6f73pppm7pmb1jl838p7siwh4vzlw1sjszr57c";
    #    })
    #    (fetchfirefoxaddon {
    #      name = "certificate-pinner";
    #      url = "https://addons.mozilla.org/firefox/downloads/file/3599612/certificate_pinner-0.17.10-an+fx.xpi";
    #      sha256 = "15qyjqca252pf28vv636fwya28pj3nnbywpkpm6cwmj1m64pmdsl";
    #    })
    # ];

    extraPolicies = {
      CaptivePortal = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DisableFirefoxAccounts = true;
      FirefoxHome = {
        Pocket = false;
        Snippets = false;
      };
       UserMessaging = {
         ExtensionRecommendations = false;
         SkipOnboarding = true;
       };
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
  # firefox
  hardenedFirefox
];

}
