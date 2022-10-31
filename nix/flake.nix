{
  description = "John's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixpkgs-22.05-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    emacs.url = "github:cmacrae/emacs";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs, nixpkgs-stable, emacs }: {
    darwinConfigurations."MacBook-Pro-5" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ 
	{
	  nix.settings.substituters = [
	    "https://cachix.org/api/v1/cache/emacs"
      "https://lean4.cachix.org/"
	  ];

	  nix.settings.trusted-public-keys = [
	    "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk="
	  ];

	  nixpkgs.overlays = [
	    # emacs.overlay
	  ];
	}
	./macos.nix
      ];
    };
  };
}
