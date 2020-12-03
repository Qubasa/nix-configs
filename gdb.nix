{pkgs, ...}:

let
  # gdb_py = (pkgs.python3.withPackages (pypkgs: with pkgs.python37Packages; [
  #     ropper
  #     capstone
  #     unicorn
  # ]));

   # gdb = pkgs.unstable.pkgs.gdb.override { python3 = gdb_py;  };

in {

environment.systemPackages = with pkgs; [
  pkgs.unstable.pkgs.gdb
];

}

