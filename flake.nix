{
  description = "Ignition Roadshow 2026 static page";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        # `nix build` -> ./result contains the publishable site
        packages.default = pkgs.runCommand "ignition2026-site" { } ''
          cp -r ${./site} $out
        '';

        # `nix run` -> serve the page locally on http://127.0.0.1:8000
        apps.default = {
          type = "app";
          program = toString (pkgs.writeShellScript "serve" ''
            exec ${pkgs.python3}/bin/python -m http.server 8000 --bind 127.0.0.1 --directory site
          '');
        };

        devShells.default = pkgs.mkShell {
          packages = [ pkgs.python3 ];
        };
      });
}
