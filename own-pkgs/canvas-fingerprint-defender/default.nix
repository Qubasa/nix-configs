{ stdenv, fetchurl, unzip, jq, zip  }:

stdenv.mkDerivation rec {
    pname = "canvas-fingerprint-defender-${version}";
    version = "0.1.5";

    extid = "@canvas-fingerprint-defender";
    signed = false;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3362272/canvas_fingerprint_defender-${version}-an+fx.xpi?src=recommended";
      sha256 = "1hg00zsrw7ij7bc222j83g2wm3ml1aj34zg5im1802cjq4qqvbld";
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
    description = "Canvas fingerprint defender firefox browser addon";
    homepage = https://mybrowseraddon.com/webgl-defender.html;
    license = {
      fullName = "Mozilla Public License Version 2.0";
      shortName = "moz2";
      spdxId = "mozilla-2.0";
      url = "https://www.mozilla.org/en-US/MPL/2.0/"; };
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
