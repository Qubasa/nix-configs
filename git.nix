{ pkgs, config, lib, ... }:

let
  unstable = import <nixos-unstable> {};
in
{

  environment.systemPackages = with pkgs; [
    unstable.git-secrets
    gitAndTools.diff-so-fancy
  ];


  environment.etc."gitconfig" = {
   text = ''
      [diff-so-fancy]
          markEmptyLines = false
          stripLeadingSymbols = false
      [pager]
          diff = ${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy \
               | ${pkgs.less}/bin/less -FRX
      [user]
          email = ${config.gitEmail}
          name = ${config.gitUser}
      [secrets]

          # Twitter Oauth 2
          patterns = [t|T][w|W][i|I][t|T][t|T][e|E][r|R].*.[0-9a-zA-Z]{35,44}

          # SSH (DSA) private key
          patterns = [-]*BEGIN.DSA.PRIVATE.KEY[-]*.*

          # Facebook Oauth 2
          patterns = [f|F][a|A][c|C][e|E][b|B][o|O][o|O][k|K].*.[0-9a-f]{32}

          # Twitter Oauth
          patterns = [t|T][w|W][i|I][t|T][t|T][e|E][r|R].*['|\"][0-9a-zA-Z]{35,44}['|\"]

          # SSH (EC) private key
          patterns = [-]*BEGIN.EC.PRIVATE.KEY[-]*.*

          # Generic AppSecret
          patterns = [a|A][p|P][p|P][s|S][e|E][c|C][r|R][e|E][t|T].*.[0-9a-zA-Z]{32,45}

          # Google Oauth 2
          patterns = [c|C][l|L][i|I][e|E][n|N][T|T][_][s|S][e|E][c|C][r|R][e|E][t|T].*[:].*[a-zA-Z0-9]{24}

          # Slack Token
          patterns = xox[p|b|o|a].*

          # Generic AppSecret 2
          patterns = [a|A][p|P][p|P][s|S][e|E][c|C][r|R][e|E][t|T].*['|\"][0-9a-zA-Z]{32,45}['|\"]

          # Generic Secret
          patterns = [s|S][e|E][c|C][r|R][e|E][t|T].*['|\"][0-9a-zA-Z]{32,45}['|\"]

          # PGP private key block
          patterns = [-]*BEGIN.PGP.PRIVATE.KEY.BLOCK[-]*.*

          # AWS API Key
          patterns = AKIA[0-9A-Z]{16}

          # Github
          patterns = [g|G][i|I][t|T][h|H][u|U][b|B].*[['|\"]0-9a-zA-Z]{35,40}['|\"]

          # RSA private key
          patterns = [-]*BEGIN.RSA.PRIVATE.KEY[-]*.*

          # Private key
          patterns = [-]*BEGIN.PRIVATE.KEY[-]*.*

          # Github 2
          patterns = [g|G][i|I][t|T][h|H][u|U][b|B].*[c|C][l|L][i|I][e|E][n|N][T|T][s|S][e|E][c|C][r|R][e|E][t|T].*[0-9a-zA-Z]{35,40}

          # Google Oauth
          patterns = (\"client_secret\":\"[a-zA-Z0-9]{24}\")

          # Facebook Oauth
          patterns = [f|F][a|A][c|C][e|E][b|B][o|O][o|O][k|K].*['|\"][0-9a-f]{32}['|\"]

          # SSH (OPENSSH) private key
          patterns = [-]*BEGIN.OPENSSH.PRIVATE.KEY[-]*.*

          # Heroku API Key
          patterns = [h|H][e|E][r|R][o|O][k|K][u|U].*[0-9A-F]{8}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{4}-[0-9A-F]{12}

          # Generic Password
          patterns = .*[p|P][a|A][s|S][s|S][w|W][o|O][r|R][d|D].*=.*

          # Classified material
          patterns = .*[c|C][o|O][n|N][f|F][i|I][d|D][e|E][n|N][t|T][i|I][a|A][l|L].*
      '';
  };


}
