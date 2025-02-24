# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  pop_shell = (
    pkgs.gnomeExtensions.pop-shell.overrideAttrs (p: {
      postInstall =
        p.postInstall or ""
        + ''
          # Workaround for NixOS/nixpkgs#92265
          mkdir --parents "$out/share/gnome-shell-extensions-46.2/glib-2.0"
          ln --symbolic "$out/share/gnome-shell/extensions/pop-shell@system76.com/schemas" "$out/share/gnome-shell-extensions-46.2/glib-2.0/schemas"

          # Workaround for NixOS/nixpkgs#314969
          mkdir --parents "$out/share/gnome-control-center"
          ln --symbolic "$src/keybindings" "$out/share/gnome-control-center/keybindings"
        '';
    })
  );
in
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
      trusted-users = root john
    '';
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs.config.allowUnfree = true;
  # Use the GRUB 2 boot loader.
  # boot.loader.grub.enable = true;
  # boot.loader.grub.version = 2;
  # boot.loader.grub.efiSupport = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  # boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  boot.loader.systemd-boot.enable = true;

  # networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  i18n.inputMethod = {
    # enabled = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [ hangul libpinyin rime ];
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-hangul
      fcitx5-chinese-addons
      fcitx5-mozc
      fcitx5-table-extra
    ];
    # fcitx5.plasma6Support = true;
  };

  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      siji # for bars or whatever
      jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-emoji
      fira-code
      font-awesome

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
  # Enable the GNOME 3 Desktop Environment.
  services.xserver.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.desktopManager.plasma6.enable = false;
  # services.desktopManager.cosmic.enable = true;

  services.xserver.displayManager.gdm.enable = false;
  services.displayManager.cosmic-greeter.enable = true;
  # services.xserver.displayManager.gdm.debug = true;
  # Workaround for NixOS/nixpkgs#92265
  # services.xserver.desktopManager.gnome.sessionPath = [ pop_shell ];

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # hardware.pulseaudio.enable = true; # give me alsa?
  # false is required with piepwire

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.john = {
    isNormalUser = true;
    initialPassword = "";
    extraGroups = [
      "wheel"
      "networkmanager"
      config.services.kubo.group
    ]; # Enable ‘sudo’ for the user.
  };

  users.defaultUserShell = pkgs.fish;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    let
      software = ((import ../software.nix) pkgs);
    in
    with pkgs;
    let
      extras = [
        kdePackages.xdg-desktop-portal-kde
        
        yt-dlp
        # play-with-mpv
        (mpv.override { scripts = [mpvScripts.youtube-upnext]; })
        nixd
        # zed-editor # cache broken
        zoxide
        zoxide # cd relacement
        # warp-terminal # kind of slow
        swi-prolog
        # sd # sed replacement, is not maintaind any more
        mu
        # lilypond-unstable
        imagemagick
        zstd
        microsoft-edge
        stack

        # gnome.pomodoro
        # I forgot what kimpanel is
        # gnomeExtensions.kimpanel
        gnomeExtensions.paperwm
        pop_shell
        emacs
        # veracrypt # I don't know what this is
        # veracrypt is very slow to build
        # teams
        clang-tools
        # (bilibili) # error with electron too old
        luarocks
        yazi # file manager
        wezterm # terminal

        nixfmt-rfc-style # formatter
        devenv # dev enviormnets
        (kdePackages.qtstyleplugin-kvantum)
        libsForQt5.qt5.qtgraphicaleffects
      ];
    in
    (builtins.concatLists [
      software.essential
      software.haskellPkgs
      # software.purescript
      software.rust
      software.latex
      software.cTools
      software.applications
      software.cmdExtras
      software.python
      # software.hyprland
      extras
    ]);

  xdg.mime.defaultApplications = {

    # "application/pdf" = "zathura.desktop";
    #                "image/png" = [
    #                  "sxiv.desktop"
    #                  "gimp.desktop"
    #            ];

  # Some programs need SUID wrappers, can be configured further or are
  };
  xdg.portal.enable = true;

  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  #

  programs.hyprland.enable = true;
  # programs.waybar.enable = true;
  programs.fish.enable = true;
  programs.steam.enable = true;
  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  # services.emacs.enable = true;
  services.flatpak.enable = true;
  services.avahi.enable = false;
  services.kubo.enable = true;
  services.pipewire.enable = true; # for hyprland

  virtualisation.docker.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
