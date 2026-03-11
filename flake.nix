{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # Note: Use the correct repo name from the instructions
    ai-tools.url = "github:numtide/llm-agents.nix"; 
  };

  # THIS IS THE KEY: It tells Nix to use the cache
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
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
          environment.systemPackages = [
            ai-tools.packages.${system}.gemini-cli
            ai-tools.packages.${system}.opencode
            ai-tools.packages.${system}.codex
          ];
        })
      ];
    };
  };
}
