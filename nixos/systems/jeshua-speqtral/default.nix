{
  self,
  nixosModules,
  nixos-unstable,
  nixos-hardware,
  lanzaboote,
  home-configs,
  ...
} @ inputs:
nixos-unstable.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = inputs;
  modules = [
    ({pkgs, config, ...}: {
      imports = with nixosModules; [
        nixos-hardware.nixosModules.lenovo-thinkpad-p1
        nixos-hardware.nixosModules.lenovo-thinkpad-p1-gen3

        ### SETTINGS ###
        ./hardware-configuration.nix
        enable-standard-hardware
        locale-sg
        nix-enable-flakes
        nix-gc
        plymouth
        power-management
        quirks-iwlwifi
        sudo-disable-timeout

        ### FEATURES ###
        chinese-input
        cloudflare-warp
        console
        enable-via-qmk
        gnome
        ios-usb
        stylix
        windows-fonts
        wireshark

        ### SECURE BOOT ###
        lanzaboote.nixosModules.lanzaboote
        secure-boot

        ### USERS ###
        (home-configs.setup-module "unstable" {
          jeshua = {
            uid = 1000;
            description = "Jeshua Lin";
            extraGroups = ["wheel" "scanner" "lp" "wireshark"];
            hmCfg = {homeModules, privateHomeModules, pkgs, ...}: {
              imports = with homeModules; [
                aesthetics
                cli-programs
                gui-programs
                gnome-shell
                privateHomeModules.awscli
                privateHomeModules.ssh-speqtral-hosts
              ];

              xdg.enable = true;

              services = {
                syncthing.enable = true;
              };

              home.packages = with pkgs; [
                powershell
                wimlib
                ciscoPacketTracer8
              ];
            };
          };
        })
      ];

      system.stateVersion = "23.11";
      networking.hostName = "jeshua-speqtral";
      nixpkgs.config.allowUnfree = true;

      ### BOOT CUSTOMIZATION ###
      boot.initrd.luks.devices."luksroot".device = "/dev/disk/by-uuid/f20dd278-e1f7-4044-b452-f8340571270f";
      system.nixos.tags = [ config.networking.hostName (toString (self.shortRev or self.dirtyShortRev or self.lastModified or "unknown")) ];

      ### ENVIRONMENT CUSTOMIZATION ###
      virtualisation.libvirtd.enable = true;
      services.flatpak.enable = true;

      ### USER SETUP ###
      users.defaultUserShell = pkgs.fish;
      programs.fish.enable = true;
      stylix.image = ./wallpaper.png;
    })
  ];
}
