{ stdenv, fetchurl  }:

stdenv.mkDerivation rec {
    pname = "https-everywhere-${version}";
    version = "2019.6.27";

    extid = "https-everywhere@eff.org";
    signed = true;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3060290/https_everywhere-${version}-an+fx.xpi";
      sha256 = "0743lhn9phn7n6c0886h9ddn1n8vhzbl0vrw177zs43995aj3frp";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      install -D ${src} "$out/${extid}.xpi"

      '';

  meta = {
    description = "Https everywhere browser addon";
    homepage = https://www.eff.org/https-everywhere;
    license = stdenv.lib.licenses.gpl2Plus;
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
