{ config, pkgs, emacs, ... }:

{


  imports = [ 

  # <home-manager/nix-darwin> 

  ];
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
    let software = ((import ./software.nix) pkgs); in
    with pkgs;
    let extras = [
          swiProlog
          bat
          hunspell
          hunspellDicts.en_US
          sd
          mu
          lilypond-unstable
          imagemagick
          zstd
          sptlrx
          sketchybar
                 ]; in
    (builtins.concatLists [
      software.essential
      software.haskellPkgs
      software.purescript
      software.rust
      software.latex
      extras
    ]) ;

  # this option is useless
  environment.loginShell = "fish";


  environment.shells = [pkgs.fish pkgs.zsh];

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/Desktop/dotfiles/nix/macos.nix";


  # autostart sketchybar pls work
  launchd.user.agents.sketchybar = {
        serviceConfig.ProgramArguments = [ "${pkgs.sketchybar}/bin/sketchybar" ];

        serviceConfig.KeepAlive = true;
        serviceConfig.RunAtLoad = true;
        serviceConfig.EnvironmentVariables = {
          PATH = "${pkgs.sketchybar}/bin:${config.environment.systemPath}";
        };
   };

  services = {
    nix-daemon.enable = true;
    spacebar = {
      enable = false; # for some reason only works on one space, does not do it on the others
      package = (import (
        fetchTarball {
          url = "https://github.com/NixOS/nixpkgs/archive/refs/heads/master.tar.gz";
        }) {}).spacebar;
  config = {
    position                   = "top";
    display                    = "all";
    height                     = 26;
    spaces                     = "on";
    title = "off";
    clock                      = "off";
    power                      = "off";
    dnd                        = "off";
    right_shell                = "off";
    right_shell_icon           = "";
    right_shell_command        = "whoami";
    center_shell = "on";
    center_shell_command = "echo hello";
  };
    };
    yabai = {
      enable = false; # I hate this this is too complicated
      enableScriptingAddition = false; # don't enable this it breaks the computer
      # package = pkgs.yabai; # this is truely idiotic, why doesn't it have a default

      package = (import (
        fetchTarball {
          url = "https://github.com/IvarWithoutBones/nixpkgs/archive/refs/heads/bump-yabai.tar.gz";
        }) {}).yabai;

    };
    skhd = {
      enable = false;
      package = pkgs.skhd;
      # skhdConfig = ''
      #   ctrl + alt + cmd - space : if [[ $(yabai -m config layout) == bsp ]]; then yabai -m config layout stack; elif [[ $(yabai -m config layout) == stack ]]; then yabai -m config layout float; else yabai -m config layout bsp; fi
      # '';
      skhdConfig = ''
ctrl + alt + cmd - space : yabai -m config layout stack
ctrl - a : osascript -e 'display notification "Lorem ipsum dolor sit amet" with title "Title"'
ctrl + alt - return : alacritty
ctrl + alt - h : yabai -m window --focus west
ctrl - n : osascript -e 'display notification "Lorem ipsum dolor sit amet" with title "Title"'
      '';

    };
    emacs = {
      enable = true;
      package = pkgs.emacs;
    };
  };
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


  system.defaults = {
    dock = {
      autohide = true;
      showhidden = true;
      mru-spaces = false;
    };
    finder = {
      AppleShowAllExtensions = true;
      QuitMenuItem = true;
      ShowStatusBar = true;
      _FXShowPosixPathInTitle = true;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = true;
      AppleFontSmoothing = 1;
      _HIHideMenuBar = true; # hide this so I can have my bar
      InitialKeyRepeat = 20;
      KeyRepeat = 1;
      NSAutomaticQuoteSubstitutionEnabled = false;
      NSAutomaticSpellingCorrectionEnabled = false;
      "com.apple.swipescrolldirection" = true;
    };
  };

  users.users.johnwang = {
    name = "John";
  };

  # home-manager.users.johnwang = {
    # programs = {
      # git = {
        # enable = true;
        # delta.enable = true;
      # };
    # };
    # home.stateVersion = "22.11";
  # };

  homebrew = {

    enable = true;
    casks = [ "virtualbox" "hammerspoon" "alacritty" ];
  };
  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # You should generally set this to the total number of logical cores in your system.
  # $ sysctl -n hw.ncpu
  nix.settings.max-jobs = 8;
  nix.settings.cores = 8;
}
