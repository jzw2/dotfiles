# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
#
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
with pkgs;
let
  my-python-packages = python-packages:
    with python-packages; [
      pyflakes
      pandas
      requests
      # lark-parser
      pyyaml
      schema
      z3
    ];
  python-with-my-packages = python3.withPackages my-python-packages;
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./cachix.nix
  ];

  nixpkgs.overlays = [
    (import (builtins.fetchGit {
      url = "https://github.com/nix-community/emacs-overlay.git";
      ref = "master";
      rev = "c98ad03b2201e17f590b6a3ec84a1c5e4722eb09";
    }))
    (self: super: {
      version = "0.3.0";
      leftwm = super.leftwm.overrideAttrs (old: rec {
        name = "leftwm";
        src = super.fetchFromGitHub {
          owner = "leftwm";
          repo = "leftwm";
          rev = "bc5d7df6ae27ea398b9395f2909b8ee132c031b8";
          sha256 = "sha256-vzA+5ijIJ5HywoftNONAOcPWTCVWiKzi0PCu2q6913E=";
        };

        cargoDeps = old.cargoDeps.overrideAttrs (super.lib.const {
          name = "${name}-vendor.tar.gz";
          inherit src;
          outputHash = "sha256-ucPSgTKBFMDOao45nPv5PJVmiJ71UBYvDg8alX8diLk=";
        });
      });
    })
  ];
  # fonts or something idk

  fonts = {
    enableDefaultFonts = true;
    fonts = with pkgs; [
      siji # for bars or whatever
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      fira-code
      font-awesome-ttf

      babelstone-han # yay I like archaick characters
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [ "Noto Sans" "Noto Sans CJK SC" ];
        monospace = [ "Noto Mono" ];
      };
    };
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Set your time zone.
  time.timeZone = "America/Chicago";

  networking = {
    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    dhcpcd.enable = false;
    #  networking.interfaces.enp1s0.useDHCP = false;
    interfaces.eth0.useDHCP = false;
    interfaces.wlan0.useDHCP = false; # uh mayby conflict with ntework manager?

    networkmanager = {
      enable = true;
      # wifi.powersave = true; # I don't know what this does, default is null? Is that false
      # powersave only works with the nl blab blah thing and not w ith wext I think
      wifi.scanRandMacAddress = false; # I hope this isnt' bad.
      # logLevel = "DEBUG";
      # extraConfig = "wifi-wext-only=true"; # i don't know why this doesn't  work
      # dhcp = "dhclient"; # hopefully this fixes some problems
      packages = [
        # pkgs.dhcpcd
      ];
    };
  };

  # networking.networkmanager.unmanaged = [
  #   "*"
  # ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.

  # Enable the GNOME 3 Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome3.enable = true;
  #
  services = {
    # dhcpd4.enable = true;
    emacs.enable = true;
    pantheon.contractor.enable = true;
    gnome.gnome-keyring.enable = true;
    gnome.games.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      # socketActivated = true;
      packages = [ pkgs.dconf ];
    };

    xserver = {
      enable = true;
      # startDbusSession = true;
      # displayManager.defaultSession = "none+xmonad";
      #       displayManager.setupCommands = ''
      #         ${pkgs.xorg.xrandr}/bin/xrandr --output HDMI-0 --auto --primary --output DP-1 --auto --right-of HDMI-0
      # '';
      windowManager.xmonad = {
        enable = true;
        enableContribAndExtras = true;
        extraPackages =
          hpkgs: [ # Open configuration for additional Haskell packages.
            hpkgs.xmonad-contrib # Install xmonad-contrib.
            hpkgs.xmonad-extras # Install xmonad-extras.
            hpkgs.xmonad # Install xmonad itself.
          ];
      };
      windowManager.leftwm.enable = true;

      # desktopManager.gnome.enable = true;
      # desktopManager.pantheon.enable = true;
      # displayManager.gdm.enable = true;
      # displayManager.gdm.nvidiaWayland = false;
      layout = "dvorak";
      videoDrivers = [ "nvidia" ];
      config = ''
        Section "Monitor"
            Identifier  "HDMI-0"
            Option      "Primary" "true"
        EndSection

        Section "Monitor"
            Identifier  "DP-1"
            Option      "RightOf" "HDMI-0"
        EndSection
      '';
    };

    logind.extraConfig = ''
      IdleAction=hybrid-sleep
      IdleActionSec=30min
      HandlePowerKey=suspend
      HandleRebootKey=ignore
    '';

  };

  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [ hangul libpinyin ];

    # enabled = "fcitx";
    fcitx.engines = with pkgs.fcitx-engines; [ hangul ];
  };

  # emacs or sometheing
  #
  # options are emacsGit, emacsUnstable, emacsGcc, emacs-nox
  # use emacsPgtk stands for pure gtk
  services.emacs.package = pkgs.emacsPgtk;

  # Configure keymap in X11
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  sound.mediaKeys.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.package =
    config.boot.kernelPackages.nvidiaPackages.legacy_470;


  hardware.opengl.extraPackages = [
    (pkgs.runCommand "nvidia-icd" { } ''
      mkdir -p $out/share/vulkan/icd.d
      cp ${pkgs.linuxPackages.nvidia_x11}/share/vulkan/icd.d/nvidia_icd.x86_64.json $out/share/vulkan/icd.d/nvidia_icd.json
    '')
  ];
  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs;
    let
      cTools = [
        cmake
        gcc
        glslang
        gnumake
        rtags

      ];

      python = [
        python-with-my-packages
        black
        pipenv
        python39Packages.isort
        python39Packages.pytest
        python39Packages.nose
        python39Packages.pyflakes
      ];

      rust = [ clippy cargo # rustc
               rustup
               racer rust-analyzer rustfmt ];
      haskell = [ ghc hlint cabal-install haskellPackages.hoogle ];

      shell = [ shellcheck ];

      json = [ jq ];

      ruby = [ # ruby
      ];
      nix = [ nixfmt ];

      allLanguages = cTools ++ python ++ rust ++ haskell ++ shell ++ json
        ++ ruby ++ nix;

      gnome = [
        #gnome
        gnome.gnome-shell-extensions
        gnome.gnome-tweaks
        whitesur-gtk-theme
        whitesur-icon-theme
        gnomeExtensions.dash-to-dock
        gnomeExtensions.lyrics-finder
        gnomeExtensions.soft-brightness
        gnomeExtensions.material-shell
        gnomeExtensions.pop-shell
      ];

      pantheon = [
        pantheon
        pantheon.switchboard
        pantheon.wingpanel
        #
      ];
      customWM = [ feh picom rofi wmctrl polybarFull ];
      programs = [
        # anki # this anki is out of date
        # adobe-reader # for some reason this is "dangerous"
        anki-bin
        audacity
        bitwarden
        brave
        discord
        firefox
        lutris
        lyrebird
        minecraft
        mpv # I don't know what this is actually
        runelite
        slack
        spotify
        spotify-tui
        spotifyd
        thunderbird
        zoom-us

        coq
        isabelle
        lean
      ];
      cmdTools = [

        ccze # log colorizer
        graphviz
        htop
        iw
        maude
        metamath
        neofetch
        tmux
        wl-clipboard

        # swaglyrics
        texlive.combined.scheme-full
        cava
        glances
      ];
      development = [

        alacritty
        exa
        fd
        gh
        git
        guake
        openssl
        pandoc
        ripgrep
        sqlite
        unzip
        neovim
        vscode
        wget
        zoxide
      ];
    in development ++ programs ++ allLanguages ++ cmdTools ++ customWM ++ [
      # development

      # working with Krist
      #     (
      #       flutter.overrideAttrs  (old:
      #         let channel = "stable";
      #             version = "2.2.2";
      #           filename = "flutter_linux_${version}-${channel}.tar.xz";
      #         in
      #                                    rec {
      #                                      inherit version;
      #                                      name = "customflutter-version";

      #  src = fetchurl {
      #       url = "https://storage.googleapis.com/flutter_infra_release/releases/${channel}/linux/${filename}";
      #       # sha256 = "sha256-0000000000000000000000000000000000000000000=";
      # sha256 = "sha256-2h68WXVjtdPkbY/Vu1BcrmRUQ8G2U9e0++18CD9NSYo=";
      #     };
      #                                    })
      #     )
      #
      #     flutter.override { pname = "oldflutter"; version = "2.2.2";

      #  src =

      #         let channel = "stable";
      #             version = "2.2.2";
      #           filename = "flutter_linux_${version}-${channel}.tar.xz"; in
      #    fetchurl {
      #       url = "https://storage.googleapis.com/flutter_infra_release/releases/${channel}/linux/${filename}";
      #       # sha256 = "sha256-0000000000000000000000000000000000000000000=";
      # sha256 = "sha256-2h68WXVjtdPkbY/Vu1BcrmRUQ8G2U9e0++18CD9NSYo=";
      #     };
      #                      }
      # android-tools

      # commandline programs

      # applications

      capitaine-cursors

    ];

  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.pantheon-tweaks.enable = true;
  nixpkgs.config.allowUnfree = true;

  virtualisation.virtualbox.host.enable = true;
  virtualisation.docker.enable = true;
  # virtualisation.virtualbox.host.enableExtensionPack = true; # slow to compile
  nix = {
    package = pkgs.nixUnstable; # or versioned attributes like nix_2_4
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = false; # reboot is kind of annoying.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
