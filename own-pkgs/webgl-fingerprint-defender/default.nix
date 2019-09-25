{ stdenv, fetchurl, unzip, jq, zip  }:

stdenv.mkDerivation rec {
    pname = "webgl-fingerprint-defender-${version}";
    version = "0.1.2";

    extid = "@webgl-fingerprint-defender";
    signed = false;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3362869/webgl_fingerprint_defender-${version}-an+fx.xpi";
      sha256 = "06hfr5hxr4qw0jx6i9fi9gdk5211z08brnvqj2jlmpyc3dwl4pif";
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
    description = "Canvas defender firefox browser addon";
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
