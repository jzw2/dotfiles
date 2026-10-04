# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  nix = {
    # package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      extra-substituters = https://devenv.cachix.org
      extra-trusted-public-keys = devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=
    '';
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Enable the GNOME Desktop Environment.
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  i18n.inputMethod = {
    # enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [ hangul libpinyin rime ];
    enable = true;
    fcitx5.waylandFrontend = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      fcitx5-hangul
      qt6Packages.fcitx5-chinese-addons
      # fcitx5-mozc
      fcitx5-table-extra
    ];
    # fcitx5.plasma6Support = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      # siji # for bars or whatever
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      # noto-fonts-emoji
      fira-code
      font-awesome
      newcomputermodern

      # babelstone-han # yay I like archaick characters

      nerd-fonts.fira-code
    ];

    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif" ];
        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK SC"
        ];
        monospace = [ "Noto Mono" ];
      };
    };

  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    # jack.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."john" = {
    isNormalUser = true;
    description = "john";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      #  thunderbird
    ];
    defaultUserShell = pkgs.fish;
  };

  programs = {
    firefox.enable = true;

    neovim = {
      enable = true;
      withPython3 = true;
      defaultEditor = true;
      configure = {
        customLuaRC = builtins.readFile ../../neovim/init.lua;

        packages.myVimPackage = with pkgs.vimPlugins; {
          # loaded on launch
          start = [
            Coqtail
            nvim-lspconfig
            nvim-autopairs
          ];
          # manually loadable by calling `:packadd $plugin-name`
          opt = [ ];
        };

      };
    };
    steam = {
      enable = true;
    };

    fish.enable = true;

  };

  # Install firefox.
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages =
    let
      software = ((import ../software.nix) pkgs);
    in
    with pkgs;
    let
      extras = [
        (python3.withPackages (ps: [ ps.pynvim ]))
        (agda.withPackages [
          agdaPackages.standard-library
        ])
        beeper

        whitesur-cursors
        whitesur-icon-theme
        whitesur-gtk-theme

        (mpv.override { scripts = [ mpvScripts.youtube-upnext ]; })
        zoxide # cd relacement
        swi-prolog
        # sd # sed replacement, is not maintaind any more mu # mail thing
        # lilypond-unstable
        imagemagick
        zstd # don't know what this is
        microsoft-edge
        stack # haskell whatever
        tinymist # typst lsp typst
        typst

        obsidian
        zotero
        # tor-browser # I don't tihink I need this

        gnomeExtensions.dock-from-dash
        gnomeExtensions.blur-my-shell
        gnomeExtensions.just-perfection
        gnomeExtensions.logo-menu
        gnomeExtensions.top-bar-organizer
        gnome-pomodoro
        clang-tools
        yazi # file manager

        harper # spellcheck nixfmt-rfc-style # formatter devenv # dev enviormnets

        nixd # nixd
        lua-language-server
        nixfmt

        vscode
      ];
    in
    (builtins.concatLists [
      software.essential
      # software.haskellPkgs software.purescript software.rust software.latex
      # software.cTools
      software.applications
      software.cmdExtras
      # software.python software.hyprland
      extras
    ]);
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

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?

}
