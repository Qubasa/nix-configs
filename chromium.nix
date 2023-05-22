{ pkgs, config, lib, ... }:

let

    mychrome = pkgs.chromium.override {
        # Verify by going to chrome://gpu
        commandLineArgs = [
            "--enable-features=VaapiVideoEncoder,VaapiVideoDecoder,CanvasOopRasterization"
            "--enable-gpu-rasterization"
            "--enable-accelerated-2d-canvas"
            "--enable-accelerated-video-decode"
            "--enable-zero-copy"
            "--use-gl=angle"
            "--enable-drdc"
        ];
    };
in
{
    services.chrome-pwa.enable = true;
    environment.systemPackages =  with pkgs; [ chromium ];
    security.chromiumSuidSandbox.enable = true;
    programs.chromium = {
        enable = true;
        defaultSearchProviderEnabled = true;
        extraOpts =
        {
            "BrowserSignin" = 0;
            "SyncDisabled"  = true;
            "PasswordManagerEnabled" = false;
            "SpellcheckEnabled" = true;
            "SpellcheckLanguage" = [ "de" "en-US" ];
        };
    };
}
