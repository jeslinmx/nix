{
  description = "NixOS (and home-manager) configuration";

  inputs = {
    # flake helpers
    flake-parts.url = "github:hercules-ci/flake-parts";
    devshell.url = "github:numtide/devshell";

    # nixpkgs
    nixpkgs.url = "nixpkgs";
    nixpkgs-patched.url = "github:jeslinmx/nixpkgs/patch-1";
    nixos-unstable.url = "nixpkgs/nixos-unstable";
    nixos-2311.url = "nixpkgs/nixos-23.11";

    # NixOS modules
    lanzaboote.url = "github:nix-community/lanzaboote";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    nix-colors.url = "github:misterio77/nix-colors";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-2311.url = "github:nix-community/home-manager/release-23.11";
    home-configs.url = "path:./home-manager";
    home-configs.inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager-unstable.follows = "home-manager-unstable";
      home-manager-2311.follows = "home-manager-2311";
      private-config.follows = "private-config";
      nix-colors.follows = "nix-colors";
    };
    private-config.url = "git+ssh://git@github.com/jeslinmx/nix-private-config";
  };

  outputs = {
    flake-parts,
    devshell,
    home-configs,
    ...
  } @ inputs: flake-parts.lib.mkFlake { inherit inputs; } ( { self, lib, ... }: {
    imports = [
      devshell.flakeModule
    ];

    flake = {
      inherit (home-configs.outputs) homeModules homeConfigurations;
      nixosModules = with builtins; with lib; let
        dir = ./nixos/modules;
        dirContents = readDir dir;
        moduleFiles = filterAttrs (fname: type: (type == "regular") && (strings.hasSuffix ".nix" fname)) dirContents;
      in
      mapAttrs' (
        fname: _:
        attrsets.nameValuePair
        (strings.removeSuffix ".nix" fname)
        (import /${dir}/${fname})
        )
        moduleFiles;
        nixosConfigurations = with builtins; with lib; let
          dir = ./nixos/systems;
          dirContents = readDir dir;
          configFiles = filterAttrs (fname: type: type == "directory") dirContents;
        in
        mapAttrs (fname: _: (import /${dir}/${fname}) (inputs // {inherit (self) nixosModules;})) configFiles;
    };

    systems = [ "x86_64-linux" ];
    perSystem = { system, pkgs, ... }: {
      formatter = pkgs.alejandra;
      devshells.default = {
        commands = [
          { package = pkgs.nurl; category = "dev"; }
          { package = pkgs.nh; category = "build"; }
          { package = pkgs.nix-tree; category = "debug"; }
          { package = pkgs.nix-melt; category = "debug"; }
        ];
      };
    };
  });
}
