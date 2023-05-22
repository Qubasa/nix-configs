{ config, pkgs, ... }:

let
  hardenedFirefox = pkgs.wrapFirefox pkgs.firefox-esr-unwrapped {
    nixExtensions = with pkgs; [
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
        url = "https://addons.mozilla.org/firefox/downloads/file/4079064/ublock_origin-1.47.4.xpi";
        sha256 = "0n3qdsba9sdn3lfk23z3gz9fghjfsyb8qr09zim62x5sb23nqnm3";
      })
      (fetchFirefoxAddon {
        name = "bitwarden";
        url = "https://addons.mozilla.org/firefox/downloads/file/4071765/bitwarden_password_manager-2023.2.1.xpi";
        sha256 = "09nhiz665xg8gy0c72mkm19c35baim2ff9717v7svh9r3xgnwbi8";
      })
      (fetchFirefoxAddon {
        name = "bypass-paywalls-clean";
        url = "https://addons.mozilla.org/firefox/downloads/file/3871257/bypass_paywalls_clean-2.4.5.0-an+fx.xpi";
        sha256 = "19jvpny60j3ffd55451i04lrvxxwrygwrh75az4nss45y4l2d3dy";
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
