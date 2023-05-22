{ stdenv
, fetchurl
, gnutar
, autoPatchelfHook
, glibc
, gtk2
, xorg
, libgudev
, requireFile
, undmg
, lib
}:

let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "vuescan";

  # Minor versions are released using the same file name
  version = "9.7";
  versionString = builtins.replaceStrings ["."] [""] version;


  vuescan-src = requireFile rec {
    url = "https://www.hamrick.com/de/";
    name = "vuex64-9.7.95.tgz";
    hashMode = "flat";
    sha256 = "1di37gmqnf4n8pk4xj1r0qkbkkh20rgj8f0ikl64pmx4l0x26rfc";
    message = ''
        Unfortunately, we cannot download file ${name} automatically.
        Please go to ${url} to download it yourself, and add it to the Nix store
        using either
          nix-store --add-fixed sha256 ./${name}
        or
          nix-prefetch-url --type sha256 file:///path/to/${name}
      '';
  };

  meta = with lib; {
    description = "Scanner software supporting a wide range of devices";
    homepage = "https://hamrick.com/";
    license = licenses.unfree;
    platforms = [
      "x86_64-linux" "i686-linux"
    ];
  };

  linux = stdenv.mkDerivation rec {
    inherit pname version meta;

    src = vuescan-src;

    # Stripping the binary breaks the license form
    dontStrip = true;

    nativeBuildInputs = [
      gnutar
      autoPatchelfHook
    ];

    buildInputs = [
      glibc
      gtk2
      xorg.libSM
      libgudev
    ];

    unpackPhase = ''
      tar xfz $src
    '';

    installPhase = ''
      install -m755 -D VueScan/vuescan $out/bin/vuescan
    '';
  };


in linux
