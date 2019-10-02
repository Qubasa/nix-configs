{pkgs, environment, config, lib, ... }:
{
  programs.ssh.startAgent = true;

  # Aks for ssh pasword only when needed
  programs.ssh.extraConfig = ''
Host *
AddKeysToAgent yes

#Match Host * exec "test $_ = /run/current-system/sw/bin/ssh"
#RemoteCommand export TERM="xterm-256color"; bash

    '';

}
