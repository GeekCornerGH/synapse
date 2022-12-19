{
  description = "A Synapse development environment";

  # This overlay allows us to choose rust versions other than latest if desired,
  # as well as provides the rust-src extension.
  inputs.rust-overlay.url = "github:oxalica/rust-overlay";

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    rust-overlay,
  }:
    flake-utils.lib.eachDefaultSystem
    (system: let
      overlays = [ (import rust-overlay) ];
      pkgs = import nixpkgs {
        inherit system overlays;
      };

      # Select the latest, stable rust release
      rust_version = "latest";
      rust = pkgs.rust-bin.stable.${rust_version}.default.override {
        extensions = [
          # rust-analyzer requires this extension to work properly
          "rust-src"
        ];
      };
    in {
      devShells.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          # Native dependencies for running Synapse
          libffi
          libjpeg
          libpqxx
          libwebp
          libxml2
          libxslt
          postgresql
          redis
          sqlite

          # Rust tooling
          rust
          cargo
          clippy
          rust-analyzer
          rustfmt

          # Native dependencies for unit tests
          openssl

          # Development tools
          poetry
        ];

        # TODO: Is there a way we can automatically set the toolchain for PyCharm to use?
        # Set RUST_SRC_PATH environment variable for rust-analyzer to make use of.
        RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
      };
    });
}
