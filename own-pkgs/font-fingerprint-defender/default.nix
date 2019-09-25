{ stdenv, fetchurl, unzip, jq, zip  }:

stdenv.mkDerivation rec {
    pname = "font-fingerprint-defender-${version}";
    version = "0.1.0";

    extid = "@font-fingerprint-defender";
    signed = false;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3387637/font_fingerprint_defender-${version}-an+fx.xpi";
      sha256 = "1aidkvisnx6qd7hn2x756rvzmbnaz6laqbwq0j5yd86g1kc56dr0";
    };

    phases = [ "buildPhase" ];

    buildInputs = [ zip unzip jq ];

    buildPhase = ''
      mkdir -p $out/${extid}
      unzip ${src} -d $out/${extid}
      NEW_MANIFEST=$(jq '. + {"applications": { "gecko": { "id": "${extid}" }}}' $out/${extid}/manifest.json)
      echo "$NEW_MANIFEST" > $out/${extid}/manifest.json
      cd $out/${extid}
      zip -r -FS $out/${extid}.xpi *
      rm -r $out/${extid}
      '';

  meta = with stdenv.lib; {
    description = "Font fingerprint defender firefox browser addon";
    homepage = https://mybrowseraddon.com/font-defender.html;
    license = {
      fullName = "Mozilla Public License Version 2.0";
      shortName = "moz2";
      spdxId = "mozilla-2.0";
      url = "https://www.mozilla.org/en-US/MPL/2.0/"; };
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
