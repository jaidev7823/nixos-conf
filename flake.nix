{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    ai-tools.url = "github:numtide/nix-ai-tools";
  };

  outputs = { self, nixpkgs, ai-tools }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix

        ({ pkgs, ... }: {
          environment.systemPackages =
            [
              ai-tools.packages.${system}.gemini-cli
              ai-tools.packages.${system}.opencode
              ai-tools.packages.${system}.codex
            ];
        })
      ];
    };
  };
}
