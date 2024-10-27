# /etc/nixos/flake.nix
{
  description = "My configurations";

  inputs = {
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/0.1";
    nixpkgs.follows = "nixos-cosmic/nixpkgs"; # NOTE: change "nixpkgs" to "nixpkgs-stable" to use stable NixOS release

    # nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.2405.0";    
    nixos-cosmic.url = "github:lilyinstarlight/nixos-cosmic";
  };

  outputs = { self, nixpkgs, nixos-cosmic, determinate}: {
    nixosConfigurations = {
      idea = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./nix/idea/idea.nix
        ];
      };
      thinkpad = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [ 
          {
            nix.settings = {
              substituters = [ "https://cosmic.cachix.org/" ];
              trusted-public-keys = [ "cosmic.cachix.org-1:Dya9IyXD4xdBehWjrkPv6rtxpmMdRel02smYzA85dPE=" ];
            };
          }
          nixos-cosmic.nixosModules.default
          determinate.nixosModules.default
          ./nix/thinkpad/configuration.nix
        ];
      };
    };
  };
}

