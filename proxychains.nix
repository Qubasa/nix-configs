{stdenv, lib, pkgs, ...}:

{

  programs.proxychains = {
    enable = true;
    proxies = {
      myproxy = {
        enable = true;
        type = "http";
        host = "127.0.0.1";
        port = 54321;
      };
    };
  };


  environment.systemPackages = with pkgs; [
    mitmproxy
  ];

}
