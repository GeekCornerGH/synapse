{ pkgs, ... }:

{
  # Configure packages to install
  packages = with pkgs; [
    # Native dependencies for running Synapse
    libffi
    libjpeg
    libpqxx
    libwebp
    libxml2
    libxslt
    sqlite

    # Native dependencies for unit tests
    openssl

    # Development tools
    poetry
  ];

  # https://devenv.sh/languages/
  languages.python.enable = true;
  languages.python.package = pkgs.python311;
  languages.rust.enable = true;

  # Enable redis
  services.postgres.enable = true;
  services.postgres.initdbArgs = ["--locale=C" "--encoding=UTF8"];
  services.postgres.initialDatabases = [
    { name = "synapse"; }
  ];

  # Enable postgres
  services.redis.enable = true;
}
