# /etc/nixos/flake.nix
{
  description = "My configurations";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-unstable";
    };
  };

  outputs = { self, nixpkgs }: {
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
          ./nix/thinkpad/configuration.nix
        ];
      };
    };
  };
}

