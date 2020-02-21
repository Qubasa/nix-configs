{
    stdenv, fetchFromGitHub
}:
stdenv.mkDerivation rec {
    pname = "userjs-hardened";
    version = "1.0";

    src = fetchFromGitHub {
	owner = "pyllyukko";
	repo = "user.js";
	rev = "d97dc6fc13ef2464289a13dadea623d71bc1b5c9";
        sha256 = "0vnnf4fy756f2j77pskk51n3ndgabahrnr7kmwwrddd237j9f0w7";
    };

    phases = [ "unpackPhase" "installPhase"  ];

    installPhase = ''
        mkdir -p $out/firefox-profile
        substitute $src/user.js $out/firefox-profile/user.js --replace user_pref lockPref
    '';
}
