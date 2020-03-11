{ stdenv, makeWrapper,
  gawk,
  coreutils,
  gnugrep,
  calc,
  wirelesstools,
  iproute,
  alsaUtils,
  gnused,
  lm_sensors,
  acpilight,
  acpi,
}:

stdenv.mkDerivation rec {

  pname   = "waybar_renderer";
  version = "1.0.0";

  src = ./src;

  buildInputs = [ makeWrapper ];

  runtimeDeps = stdenv.lib.makeBinPath [
    gawk
    coreutils
    gnugrep
    calc
    wirelesstools
    iproute
    alsaUtils
    gnused
    lm_sensors
    acpilight
    acpi
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp $src/waybar_render $out/bin/waybar_renderer
    cp -r $src/lib/ $out/lib

    echo ${runtimeDeps}
    wrapProgram $out/bin/waybar_renderer --prefix PATH : "${runtimeDeps}:$out/lib"
  '';
}
