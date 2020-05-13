{ stdenv, fetchurl  }:

stdenv.mkDerivation rec {
    pname = "ublock-origin-${version}";
    version = "1.24.2";

    extid = "uBlock0@raymondhill.net";
    signed = true;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3452970/ublock_origin-${version}-an+fx.xpi";
      sha256 = "0kjjwi91ri958gsj4l2j3xqwj4jgkcj4mlqahqd1rz9z886sd9dy";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      install -D ${src} "$out/${extid}.xpi"
      '';

  meta = with stdenv.lib; {
    description = "ublock origin firefox browser addon";
    homepage = https://github.com/gorhill/uBlock;
    license = licenses.gpl3;
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
