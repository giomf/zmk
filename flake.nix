{
  description = "A basic python flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    flake-utils.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pp = pkgs.python312Packages;
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            pkgs.cmake
            pkgs.gcc-arm-embedded
            pkgs.just
            pkgs.ninja
            pp.pyelftools
            pp.venvShellHook
            pp.virtualenv
            pp.west
          ];
          venvDir = "./.venv";
          postVenvCreation = ''
            pip install -r zephyr/scripts/requirements.txt
            west zephyr-export
          '';
          env = {
            ZEPHYR_TOOLCHAIN_VARIANT = "gnuarmemb";
            GNUARMEMB_TOOLCHAIN_PATH = pkgs.gcc-arm-embedded;
          };
        };
      }
    );
}
