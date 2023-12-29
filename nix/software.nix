pkgs :
with pkgs;
{
  essential = [
    neovim
    pandoc
    ripgrep
    bat
    gitFull # allows git gui gitk and stuff
    gh
    unzip
    wget
    fd # find replacement
    sqlite # need it for org roam
    alacritty
    # tmux
  ];

  cmdExtras = [
    helix
    wl-clipboard
    glances
    neofetch # yes very essential
    sptlrx
    bat
    zellij
    python311Packages.habitipy
    translate-shell
    gitui # rust thing, seems beetter than lazygit

  ];


  cTools = [
    cmake
    gcc
    glslang
    gnumake
    rtags

  ];

  python = [ 
    python3Packages.python-lsp-server
    (
      python3.withPackages (pyPkgs: with pyPkgs; [
        noise
        pillow
        matplotlib
        numpy

      (
        buildPythonPackage rec {
          pname = "perlin_noise";
          version = "1.12";
          src = fetchPypi {
            inherit pname version;
            sha256 = "sha256-AexC2fK8M4rlLtuwabN1+4P+xReE4XR5NmztH3BjlXw=";
          };
          doCheck = false;
          propagatedBuildInputs = [
            # Specify dependencies
            # pkgs.python3Packages.numpy
          ];
        }
      )
      ]
      )
    )
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
  haskellPkgs = [
    ghc
    hlint
    cabal-install
    haskellPackages.hoogle
    haskell-language-server
  ];

  shell = [ shellcheck ];

  json = [ jq ];

  ruby = [
    # ruby
  ];
  nix = [ nixfmt ];

  purescript = [ purescript spago esbuild
               #   nodejs

               ] ;

  latex = [
     # deprecated
     # texlive.combined.scheme-full
     texliveFull.__overrideTeXConfig { withDocs = true; }
     lua53Packages.digestif
     python3Packages.pyment
     texlab # lsp
   ] ;

  applications = [ whatsapp-for-linux spotify discord
                   # minecraft # broken
                   prismlauncher # minecraft
                   zoom-us
                   anki
                    (lutris.override {
        extraPkgs = pkgs: [
            wineWowPackages.staging
            winetricks
            wineWowPackages.waylandFull
        ];
    }) # use flatpak apparently is better
                 ] ;
  hyprland = [ 
     wofi
     kitty
     pipewire
     dunst
     bluetuith
      wl-clipboard
  ];


}
