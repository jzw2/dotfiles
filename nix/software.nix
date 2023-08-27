pkgs :
with pkgs;
{
  essential = [
    neovim
    pandoc
    ripgrep
    bat
    neofetch # yes very essential
    gitFull # allows git gui gitk and stuff
    gh
    unzip
    wget
    fd # find replacement
    sqlite # need it for org roam
    alacritty
    # tmux
    glances 
  ];


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
    # python39Packages.pytest
    python39Packages.nose
    python39Packages.pyflakes
  ];

  rust = [

  # clippy
  # cargo
  # rustc
  # rustup
  # racer

  # rust-analyzer

  # rustfmt

  rustup
  ];
  haskellPkgs = [ ghc hlint cabal-install haskellPackages.hoogle ];

  shell = [ shellcheck ];

  json = [ jq ];

  ruby = [
    # ruby
  ];
  nix = [ nixfmt ];

  purescript = [ purescript spago esbuild
               #   nodejs

               ] ;

  latex = [ texlive.combined.scheme-medium texlab lua53Packages.digestif ] ;

  applications = [ whatsapp-for-linux spotify discord
                   # minecraft # broken
                   prismlauncher # minecraft
                   # lutris # use flatpak apparently is better
                 ] ;
  hyprland = [ 
     wofi
     kitty
     pipewire
     dunst
  ];

}
