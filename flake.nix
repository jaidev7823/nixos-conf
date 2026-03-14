{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    ai-tools.url = "github:numtide/llm-agents.nix";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  outputs = { self, nixpkgs, ai-tools, home-manager }:
  let
    system = "x86_64-linux";
  in {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager

        ({ pkgs, ... }: {
          environment.systemPackages = [
            ai-tools.packages.${system}.gemini-cli
            ai-tools.packages.${system}.opencode
            ai-tools.packages.${system}.codex
            ai-tools.packages.${system}.agent-browser
          ];
        })
      ];
    };
  };
}
