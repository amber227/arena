{
  description = "Simple FHS user environment";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
      };

      fhsEnv = pkgs.buildFHSUserEnv {
        name = "fhs-env";

        targetPkgs = pkgs: with pkgs; [
          bash
          coreutils
          findutils
          gawk
          gnugrep
          gnutar
          gzip
          git
          wget
          curl
          gcc
          gnumake
          pkg-config
        ];

        runScript = "bash";
      };
    in
    {
      # nix run .#fhs-env
      apps.${system}.default = {
        type = "app";
        program = "${fhsEnv}/bin/fhs-env";
      };

      # # nix run .#
      # apps.${system}.default = self.apps.${system}.fhs-env;

      # Optional: expose as a package too
      # packages.${system}.fhs-env = fhsEnv;
      # packages.${system}.default = fhsEnv;
    };
}
