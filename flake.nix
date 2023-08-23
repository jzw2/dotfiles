# /etc/nixos/flake.nix
{
  description = "Flake fro the ideapad";

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
    };
  };
}

