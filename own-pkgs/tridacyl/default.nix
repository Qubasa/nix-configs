{ stdenv, fetchurl  }:

stdenv.mkDerivation rec {
    pname = "tridactyl-${version}";
    version = "1.17.1";

    extid = "tridactyl.vim@cmcaine.co.uk";
    signed = true;
    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3441168/tridactyl-1.17.1-an+fx.xpi";
      sha256 = "0v5rlzpzsi0zq6da5yi5n1rjc7ra07vjr0rn1v1sjssqfjagl9wl";
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
