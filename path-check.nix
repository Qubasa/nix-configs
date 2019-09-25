
{pkgs, lib, ...}:

let

  action = pkgs.writeScript "checkPathAction.sh" ''
      echo "Press ENTER..."
      read
    '';

  checkPath = pkgs.writeScript "checkPath.sh" ''
#!/bin/sh

BLACKLISTED="su sudo"
RED='\033[0;31m'
NC='\033[0m' # No Col

if [ "$(${pkgs.coreutils}/bin/id -u)"  != "0" ]; then
  P=$(echo "$PATH" | ${pkgs.gnused}/bin/sed 's/:/ /g')

  # Split path on :
  for SPATH in $P; do
	  # Check if path is writeable by user
	  if test -w "$SPATH"; then

		  # Iterate over every file in path
          for FILE in $(${pkgs.findutils}/bin/find "$SPATH" -maxdepth 1 -type f -printf "%f " && \
          ${pkgs.findutils}/bin/find "$SPATH" -maxdepth 1 -type l -printf "%f "); do

			  # Iterate over every file name in BLACKLISTED
			  for BL in $BLACKLISTED; do

				  # Check if current file name matches blacklited file name
				  if [ "$FILE" = "$BL" ];then

					  # Check if file is executable by user
					  if test -x "$SPATH/$FILE";then
						  echo -e "$RED DANGER: Someone is hijacking your $BL executable!!$NC"
						  echo -e "$RED Location: $SPATH/$BL $NC"
						  ${action}
					  fi
				  fi
			  done
		  done
	  fi
  done
fi
    '';
in
  {
    environment.interactiveShellInit = '' ${checkPath} '';
  }
