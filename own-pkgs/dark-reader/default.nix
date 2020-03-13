{ stdenv, fetchurl  }:

stdenv.mkDerivation rec {
    pname = "dark-reader-${version}";
    version = "4.8.10";

    extid = "addon@darkreader.org";
    signed = true;
    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3519548/dark_reader-4.8.10-an+fx.xpi";
      sha256 = "14py96jdl1c5xhcva8z4p7d33fdfj1p1iqahxyx4glkrdq1i0yal";
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
