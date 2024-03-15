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

  # hp-check
  environment.systemPackages = with pkgs; [
    hplipWithPlugin
  #  xsane
  ];

  # Printer discovery
  services.avahi.enable = true;
  # Important to resolve .local domains of printers, otherwise you get an error
  # like  "Impossible to connect to XXX.local: Name or service not known"
  #services.avahi.nssmdns = true;
#  services.avahi.nssmdns4 = true;

}
