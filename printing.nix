{pkgs, config, ...}:

{

  #  Users in the "scanner" group will gain access to the scanner, or the "lp" group if it's
  # also a printer.
  hardware.sane.enable = true;

  # update nix-locate database periodically
  services.locate.enable = true;

  # Printing support
  services.printing.enable = true;
  services.printing.drivers = with pkgs; [
    hplipWithPlugin
  ];

  # Printer discovery
  services.avahi.enable = false;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  services.avahi.nssmdns = false;

}