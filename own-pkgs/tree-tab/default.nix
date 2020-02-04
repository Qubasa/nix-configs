{ stdenv, fetchurl  }:

stdenv.mkDerivation rec {
    pname = "tree-tab-${version}";
    version = "3.3.4";

    extid = "treestyletab@piro.sakura.ne.jp";
    signed = true;

    src = fetchurl {
      url = "https://addons.mozilla.org/firefox/downloads/file/3484971/tree_style_tab_-${version}-fx.xpi?src=dp-btn-primary";
      sha256 = "0bab05ll9wgzkh96x62mzajmlcwf01gdcrr13wiwxibd3055ip6w";
    };

    phases = [ "installPhase" ];

    installPhase = ''
      install -D ${src} "$out/${extid}.xpi"
      '';

  meta = with stdenv.lib; {
    description = "treetab firefox browser addon";
    homepage = https://piro.sakura.ne.jp/xul/_treestyletab.html.en;
    license = licenses.gnu3;
    maintainers = [];
    platforms = stdenv.lib.platforms.all;
  };
}
