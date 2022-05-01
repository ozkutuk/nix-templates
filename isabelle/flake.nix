{
  description = "An Isabelle environment bundled with VSCodium";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        # Under "User Settings", set `isabelle.home` to the store path.
        # You can obtain the path through `which isabelle`:
        #
        # $ which isabelle
        # /nix/store/g6vfk55p2r1yd7dg321lnzm4z0shb96f-isabelle-2021-1/bin/isabelle
        #
        # So the `isabelle.home` should point to:
        # /nix/store/g6vfk55p2r1yd7dg321lnzm4z0shb96f-isabelle-2021-1/Isabelle2021-1
        isabelle = pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "Isabelle2021-1";
          publisher = "makarius";
          version = "1.2.2";
          sha256 = "sha256-07keMtO7xm77NQXxxiWpZrL2Ycv1NWLdN+f/oBUUn5Y=";
        };

        # Under "User Settings", set the following:
        # "prettifySymbolsMode.substitutions": [
        #   {
        #     "language": "isabelle",
        #     "revealOn": "none",
        #     "adjustCursorMovement": true,
        #     "prettyCursor": "none",
        #     "substitutions": []
        #   },
        #   {
        #     "language": "isabelle-ml",
        #     "revealOn": "none",
        #     "adjustCursorMovement": true,
        #     "prettyCursor": "none",
        #     "substitutions": []
        #   }]
        prettify-symbols-mode = pkgs.vscode-utils.extensionFromVscodeMarketplace {
          name = "prettify-symbols-mode";
          publisher = "siegebell";
          version = "0.4.2";
          sha256 = "sha256-yHbU9pKekSu6OahpOniGlja5lAYSDUP69YNSmLxM+0o=";
        };

        extensions = [
          isabelle
          prettify-symbols-mode
          # optional: Vim emulation
          pkgs.vscode-extensions.vscodevim.vim
        ];

        vscodium-with-extensions = pkgs.vscode-with-extensions.override {
          vscode = pkgs.vscodium;
          vscodeExtensions = extensions;
        };

      in {
        devShell = pkgs.mkShell {
          buildInputs = [
            pkgs.isabelle
            vscodium-with-extensions
          ];
        };
      });
}
