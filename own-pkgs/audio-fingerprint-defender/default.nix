{ stdenv, fetchurl, unzip, jq, zip  }:

stdenv.mkDerivation rec {
    pname = "audio-fingerprint-defender-${version}";
    version = "0.1.3";

    extid = "@audio-fingerprint-defender";
    signed = false;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3363623/audiocontext_fingerprint_defender-${version}-an+fx.xpi";
      sha256 = "0yfk5vqwjg4g25c98psj56sw3kv8imxav3nss4hbibflgla1h5pb";
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
    description = "Audio context fingerprint defender firefox browser addon";
    homepage = https://mybrowseraddon.com/audiocontext-defender.html;
    license = {
      fullName = "Mozilla Public License Version 2.0";
      shortName = "moz2";
      spdxId = "mozilla-2.0";
      url = "https://www.mozilla.org/en-US/MPL/2.0/"; };
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
