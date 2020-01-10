{ stdenv, fetchurl  }:

stdenv.mkDerivation rec {
    pname = "dark-reader-${version}";
    version = "4.8.6";

    extid = "addon@darkreader.org";
    signed = true;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3461726/dark_reader-${version}-an+fx.xpi";
      sha256 = "05mmyfhl0xynzbsncpfj24rajv945zj57pjlid3bar97w0xshfi4";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      install -D ${src} "$out/${extid}.xpi"

      '';

  meta = {
    description = "Dark reader firefox addon";
    homepage = https://outgoing.prod.mozaws.net/v1/3898cac9f9fd2d2702f9668f877d1e6066acd4864d5d806cf311f15502a17be1/https%3A//darkreader.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
