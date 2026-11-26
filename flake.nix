{
  description = "Ignition2026 MkDocs documentation site";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        python = pkgs.python3.withPackages (ps: [
          ps.mkdocs
          ps.mkdocs-material
        ]);
      in
      {
        packages.default = pkgs.stdenvNoCC.mkDerivation {
          pname = "ignition2026-site";
          version = "0.1.0";
          src = ./.;
          nativeBuildInputs = [ python ];
          buildPhase = ''
            mkdocs build --strict --site-dir $out
          '';
          dontInstall = true;
        };

        devShells.default = pkgs.mkShell {
          packages = [ python ];
          shellHook = ''
            echo "mkdocs serve  - live preview at http://127.0.0.1:8000"
            echo "mkdocs build  - build the site into ./site"
          '';
        };
      });
}
