{
  description = "NixOS system";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    ai-tools.url = "github:numtide/llm-agents.nix";
    whisp-away.url = "github:madjinn/whisp-away";
  };

  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  outputs = inputs@{ self, nixpkgs, ai-tools, home-manager, whisp-away, ... }:
    let
      system = "x86_64-linux";
    in
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          ./configuration.nix
          home-manager.nixosModules.home-manager

          # Correct attribute name found via nix flake show
          whisp-away.nixosModules.nixos

          ({ pkgs, ... }: {
            services.whisp-away = {
              enable = true;
              defaultModel = "base.en";
              defaultBackend = "whisper-cpp";
              accelerationType = "vulkan";
              useClipboard = false;
              useCrane = false;
            };

services.postgresql = {
  enable = true;
  package = pkgs.postgresql_16;

  ensureDatabases = [ "mydatbase1" "real-estate" ];

  ensureUsers = [{
    name = "mydatbase1";
    ensureDBOwnership = true;
  }];

  settings = {
    # Use lib.mkForce here
    listen_addresses = pkgs.lib.mkForce "*";
  };

  authentication = ''
    # local connections
    local   all   all                   trust

    # allow Docker / external connections
    host    all   all   0.0.0.0/0       md5
  '';
};

            environment.systemPackages = [
              ai-tools.packages.${system}.gemini-cli
              ai-tools.packages.${system}.opencode
              ai-tools.packages.${system}.codex
              ai-tools.packages.${system}.agent-browser
              ai-tools.packages.${system}.pi
              whisp-away.packages.${system}.whisp-away
              pkgs.zoxide
            ];
          })
        ];
      };
    };
}
