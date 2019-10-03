{ stdenv, fetchurl, unzip, jq, zip  }:

stdenv.mkDerivation rec {
    pname = "user-agent-switcher-${version}";
    version = "0.3.2";

    extid = "@user-agent-switcher";
    signed = false;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3370255/user_agent_switcher_and_manager-${version}-an+fx.xpi";
      sha256 = "0lrw1xf6fsxr47bifkayfxpysv8s2p9ghmbmw2s7ymhrgy42i6v5";
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
    description = "User agent switcher";
    homepage = https://add0n.com/useragent-switcher.html;
    license = {
      fullName = "Mozilla Public License Version 2.0";
      shortName = "moz2";
      spdxId = "mozilla-2.0";
      url = "https://www.mozilla.org/en-US/MPL/2.0/"; };
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
