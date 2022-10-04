{
  description = "John's darwin system";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-20.09-darwin";
    darwin.url = "github:lnl7/nix-darwin/master";
    inputs.emacs.url = "github:cmacrae/emacs";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, darwin, nixpkgs, emacs }: {
    darwinConfigurations."Johns-MacBook" = darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ 
	./macos.nix 
	{
	  nix.binaryCaches = [
	    "https://cachix.org/api/v1/cache/emacs"
	  ];

	  nix.binaryCachePublicKeys = [
	    "emacs.cachix.org-1:b1SMJNLY/mZF6GxQE+eDBeps7WnkT0Po55TAyzwOxTY="
	  ];

	  nixpkgs.overlays = [
	    emacs.overlay
	  ];
	}
      ];
    };
  };
}
