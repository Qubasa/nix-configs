{ config, pkgs, lib, ... }:

let
  get_blocklist = pkgs.writeScript "get_blocklist" (lib.readFile ./get_blocklists.sh);

in
{
  # Set own dns server
 # networking.networkmanager = {
 #  dns = "systemd-resolved";
 # };

 services.resolved = {
    enable = false;
  };

  systemd.timers."get_block_list" = {
    enable = true;
    wantedBy = [ "multi-user.target" "timers.target" ];
    timerConfig = {
      OnCalendar = "0/3:00:00"; # Update every 3 hours
      RemainAfterElapse = true;
      Persistent = true;
      OnBootSec = 120;
    };
  };

  systemd.services."get_block_list" = {
    enable = false;
    wants = [ "unbound.service" ];
    after = [ "network.target" "unbound.service" ];
    path = with pkgs; [ bash curl coreutils gawk gnugrep ];
    serviceConfig = {
      ExecStart = "${get_blocklist}";
      WorkingDirectory = "/var/lib/unbound";
    };
  };

  systemd.services.unbound = {
    preStart = "touch /var/lib/unbound/ads.txt";
  };



  services.unbound = {
    enable = false;

    settings = {
      server = {
        interface = [ "127.0.0.1" ];
        access-control = [ "::/0 allow" ];
        include = [
          "/var/lib/unbound/ads.txt"
#          "/var/lib/unbound/local_deny.unbound"
        ];
        use-syslog = "yes";
        verbosity = "1";
        private-address = [
          "192.168.0.0/16"
          "169.254.0.0/16"
          "172.16.0.0/12"
          "10.0.0.0/8"
          "fd00::/8"
          "fe80::/10"
        ];

        # Reduce EDNS reassembly buffer size.
        # Suggested by the unbound man page to reduce fragmentation reassembly problems
        edns-buffer-size = "1472";

        # buffer size for UDP port 53 incoming (SO_RCVBUF socket option). This sets
        # the kernel buffer larger so that no messages are lost in spikes in the traffic.
        so-rcvbuf = "1m";

        # Increase the memory size of the cache. Use roughly twice as much rrset cache
        # memory as you use msg cache memory. Due to malloc overhead, the total memory
        # usage is likely to rise to double (or 2.5x) the total cache memory. The test
        # box has 4gig of ram so 256meg for rrset allows a lot of room for cacheed objects.
        rrset-cache-size = "256m";
        msg-cache-size = "128m";

        # perform prefetching of close to expired message cache entries.  If a client
        # requests the dns lookup and the TTL of the cached hostname is going to
        # expire in less than 10% of its TTL, unbound will (1st) return the ip of the
        # host to the client and (2nd) pre-fetch the dns request from the remote dns
        # server. This method has been shown to increase the amount of cached hits by
        # local clients by 10% on average.
        prefetch = "yes";

        # Use 0x20-encoded random bits in the query to foil spoof attempts.
        # http://tools.ietf.org/html/draft-vixie-dnsext-dns0x20-00
        # While upper and lower case letters are allowed in domain names, no significance
        # is attached to the case. That is, two names with the same spelling but
        # different case are to be treated as if identical. This means calomel.org is the
        # same as CaLoMeL.Org which is the same as CALOMEL.ORG.
        use-caps-for-id = "yes";

        # Require DNSSEC data for trust-anchored zones, if such data is absent, the
        # zone becomes  bogus.  Harden against receiving dnssec-stripped data. If you
        # turn it off, failing to validate dnskey data for a trustanchor will trigger
        # insecure mode for that zone (like without a trustanchor).  Default on,
        # which insists on dnssec data for trust-anchored zones.
        harden-dnssec-stripped = "no";

        # Do not downgrade encryption
        harden-algo-downgrade = "no";

        # enable to not answer id.server and hostname.bind queries.
        hide-identity = "yes";

        # enable to not answer version.server and version.bind queries.
        hide-version = "yes";

        # DNS over TLS
        #tls-service-key: /var/lib/acme/qube.email/key.pem
        #tls-service-pem: /var/lib/acme/qube.email/cert.pem
        #tls-port: 853
        #https-port: 854

        # Reflection attack prevention
        deny-any = "yes";
        do-udp = "yes";
        do-tcp = "yes";
        do-ip6 = "yes";
      };
    };
  };

  boot.kernel.sysctl = {
    "net.core.rmem_max" = 1048576;
  };

  # For DNS over HTTPS see
  # https://github.com/Mic92/dotfiles/blob/072dbeb38f6e81a5f8ee0d3d2f6fad462a706d17/nixos/eve/modules/kresd.nix#L19
  # https://github.com/Mic92/dotfiles/blob/master/nixos/modules/networkd.nix#L33

}
