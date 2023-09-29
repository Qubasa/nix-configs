{ config, pkgs, ... }:

let
  hardenedFirefox = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
    nixExtensions = with pkgs; [
      (fetchFirefoxAddon {
        name = "react-dev-tools";
        url = "https://addons.mozilla.org/firefox/downloads/file/4113335/react_devtools-4.27.8.xpi";
        sha256 = "sha256-+uHDXnMZhOQ3UwDfDE2O4jPsEM2r5Mr+XPrKCA4GNEY=";
      })
      (fetchFirefoxAddon {
        name = "user_agent_switcher";
        url = "https://addons.mozilla.org/firefox/downloads/file/4047133/user_agent_string_switcher-0.4.9.xpi";
        sha256 = "sha256-YXq3JkGfbBrd7ccnrUHcoY9S+940r1ntfUJCXxORKdE=";
      })
      (fetchFirefoxAddon {
        name = "langpack-de";
        url = "https://addons.mozilla.org/firefox/downloads/file/3971556/deutsch_de_language_pack-102.0.1buildid20220705.093820.xpi";
        sha256 = "sha256-0X+Ibrx/lOEiI4LCajtBz2RzjUMkuJd27p5Vw0hyGLY=";
      })
      (fetchFirefoxAddon {
        name = "darkreader";
        url = "https://addons.mozilla.org/firefox/downloads/file/4053589/darkreader-4.9.62.xpi";
        sha256 = "sha256-5TeizuRe18JveezT7TYmIOPwDSTBWFMqWOFjpjo9YMw=";
      })
      (fetchFirefoxAddon {
        name = "ublock";
        url = "https://addons.mozilla.org/firefox/downloads/file/4164949/ublock_origin-1.52.0.xpi";
        sha256 = "sha256-OTJQbOTfMG5Np1J9k9YP4EIc8VBFwvTqc1idmgkCJms=";
      })
      (fetchFirefoxAddon {
        name = "bitwarden";
        url = "https://addons.mozilla.org/firefox/downloads/file/4071765/bitwarden_password_manager-2023.2.1.xpi";
        sha256 = "09nhiz665xg8gy0c72mkm19c35baim2ff9717v7svh9r3xgnwbi8";
      })
      (fetchFirefoxAddon {
        name = "bypass-paywalls-clean";
        url = "https://gitlab.com/magnolia1234/bpc-uploads/-/raw/master/bypass_paywalls_clean-3.2.0.0.xpi";
        sha256 = "sha256-cLpL8/3+4gAc/Qs9iD90xxFJvlNbuOCILy6JdrzPsYs=";
      })
    ];

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

      // Disable js in PDFs
      lockPref("pdfjs.enableScripting", false);
    '';

  };

in
{

  environment.variables = {
    BROWSER = [ "firefox" ];
  };

  environment.systemPackages = with pkgs; [
    hardenedFirefox
  ];

}
