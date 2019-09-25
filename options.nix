{config, lib, ...}:
{
  options.mainUser = lib.mkOption {
    type = lib.types.str;
  };

  options.mainUserHome = lib.mkOption {
    type = lib.types.str;
  };

  options.secrets = lib.mkOption {
    type = lib.types.str;
  };

  options.wallpapers = lib.mkOption {
    type = lib.types.str;
  };

  options.screenlock_imgs = lib.mkOption {
    type = lib.types.str;
  };

  options.gitUser = lib.mkOption {
    type = lib.types.str;
  };

  options.gitEmail = lib.mkOption {
    type = lib.types.str;
  };
}
