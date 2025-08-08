#https://nix.dev/manual/nix/2.24/introduction
#nix profile install path:/root/.config/nix/nvim-flake --priority 0
#nix profile upgrade nvim-flake
#sha256 = "0000000000000000000000000000000000000000000000000000";
{
  description = "Dev environment with Neovim, Git, Zsh, and more";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, flake-utils, nixpkgs, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
        };

        neovimPkgs = import (builtins.fetchTarball {
          #https://lazamar.co.uk/nix-versions/?package=neovim&version=0.9.5&fullName=neovim-0.9.5&keyName=neovim&revision=e89cf1c932006531f454de7d652163a9a5c86668&channel=nixpkgs-unstable#instructions
          #nvim 0.11.2
          url = "https://github.com/NixOS/nixpkgs/archive/e6f23dc08d3624daab7094b701aa3954923c6bbb.tar.gz";
          sha256 = "0m0xmk8sjb5gv2pq7s8w7qxf7qggqsd3rxzv3xrqkhfimy2x7bnx";
        }) {
          inherit system;
        };

        azPkgs = import (builtins.fetchTarball {
          #https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=azure-cli
          #az 2.71.0
          url = "https://github.com/NixOS/nixpkgs/archive/3e2cf88148e732abc1d259286123e06a9d8c964a.tar.gz";
          sha256 = "1gvlrbl3fx1fwyb26w5k8rdlxnhzf11si7pzf3khw9n1v4jhqdw0";
        }) {
          inherit system;
        };

        bicepPkgs = import (builtins.fetchTarball {
          #https://lazamar.co.uk/nix-versions/?channel=nixpkgs-unstable&package=bicep
          #bicep v0.33.93
          url = "https://github.com/NixOS/nixpkgs/archive/0bd7f95e4588643f2c2d403b38d8a2fe44b0fc73.tar.gz";
          sha256 = "0vx2pw69if88nkfh74bf1a8s5497n2nv7wydmvmqh5qh00fsahvq";
        }) {
          inherit system;
        };

        dotnetCombined = pkgs.dotnetCorePackages.combinePackages [
            pkgs.dotnetCorePackages.sdk_8_0
            pkgs.dotnetCorePackages.sdk_9_0
          ];

      in {
        packages.default = pkgs.buildEnv {
          name = "full-dev-env";
          paths = with pkgs; [
            # Core tools
            pkgs.zsh
            pkgs.git
            pkgs.curl
            pkgs.inetutils  # includes `ping`
            pkgs.gh
            pkgs.gawkInteractive # awk
            pkgs.gnused # sed
            pkgs.zip
            pkgs.unzip
            pkgs.wget
            pkgs.iproute2
            pkgs.jq

            # Editors & tools
            neovimPkgs.neovim
            pkgs.ripgrep
            pkgs.fd
            pkgs.tmux

            # Clipboard
            pkgs.xclip

            # Extras
            pkgs.docker
            pkgs.lf
            pkgs.lazysql

            azPkgs.azure-cli
            bicepPkgs.bicep

            dotnetCombined
            pkgs.nodejs
            pkgs.nodePackages.npm

            pkgs.gcc
          ];

          # Optional: ensure `man` pages and bin links are preserved
          pathsToLink = [ "/bin" "/share/man" ];
        };
      }
    );
}
