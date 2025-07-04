#nix profile install --extra-experimental-features "nix-command flakes" path:.config/nix/nvim-flake
{
  description = "Dev environment with Neovim, Git, Zsh, and more";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };
      in {
        packages.default = pkgs.buildEnv {
          name = "full-dev-env";
          paths = with pkgs; [
            # Core tools
            zsh
            git
            curl
            inetutils  # includes `ping`
            gh
            zip
            unzip
            wget
            iproute2
            jq

            # Editors & tools
            neovim
            ripgrep
            fd
            tmux

            # Clipboard
            xclip

            # Extras
            docker
            lf
            lazysql
          ];

          # Optional: ensure `man` pages and bin links are preserved
          pathsToLink = [ "/bin" "/share/man" ];
        };
      }
    );
}
