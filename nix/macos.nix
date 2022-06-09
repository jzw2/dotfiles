{ config, pkgs, ... }:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  # # #
# ant-1.10.11
# apache-maven-3.8.5
# bat-0.21.0
# black-22.3.0
# cachix-0.7.0
# cmake-3.22.3
# du-dust-0.8.0
# esbuild-0.14.39
# exa-0.10.1
# fd-8.4.0
# ffmpeg-5.0.1
# fish-3.4.1
# gdb-12.1
# gh-2.11.3
# ghc-9.0.2
# git-with-svn-2.36.0
# go-1.18.2
# graphviz-2.50.0
# hello-2.12
# htop-3.2.0
# idris-with-packages-1.3.4
# isync-1.4.4
# jq-1.6
# libyaml-0.2.5
# libyaml-cpp-0.7.0
# lolcat-100.0.1
# man-db-2.10.2
# maude-3.1
# metamath-0.198
# mu-1.6.10
# neofetch-unstable-2021-12-10
# neovim-0.7.0
# nix-2.8.1
# nodejs-16.15.0
# node_purs-tidy-0.7.2
# node_pyright-1.1.113
# pandoc-2.17.1.1
# purescript-v0.15.2
# ranger-1.9.3
# ripgrep-13.0.0
# ruby-3.1.2
# rust-analyzer-2022-05-17
# sbcl-2.2.4
# sd-0.7.6
# spago-0.20.9
# spotify-tui-0.25.0
# sptlrx-0.2.0
# stack-2.7.5
# starship-1.7.1
# swi-prolog-8.3.29
# tmux-3.2a
# wget-1.21.3
# z3-4.8.15
# zoxide-0.8.1
# zstd-1.5.2
  environment.systemPackages =
    with ((import ./software.nix) pkgs);
    with pkgs;

    [ pkgs.vim
      pkgs.hello

      sd # replacement for sed
      htop #
      ripgrep # rust replacement for grep
      zstd # idk what this is
      lua


    ] ++ essential;

  # this option is useless
  environment.loginShell = "fish";


  environment.shells = [pkgs.fish pkgs.zsh];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/Desktop/dotfiles/nix/macos.nix";


  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Create /etc/bashrc that loads the nix-darwin environment.
  programs.bash.enable = true;
  programs.zsh.enable = true;
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
set -x EDITOR "nvim"

abbr --add aoeu darwin-rebuild switch
abbr --add cat bat
'';
    # shellAliases = {
    #   aoeu = "darwin-rebuild switch";
    #   cat = "bat";

    # };
  };
  programs.tmux = {
    enable = true;
    enableMouse = true;
    extraConfig = ''

    # I don't know why but I have to set this otherwies it gets broken
    set -g default-terminal "screen-256color"
'';
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.maxJobs = 1;
  nix.buildCores = 1;
}
