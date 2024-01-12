{ pkgs, unstable, ... }: {
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  imports = [
    ../common/enable-standard-hardware.nix
    ../common/power-management.nix
    ../common/fingerprint-auth.nix
    ../common/quirks/iwlwifi.nix
    ../common/secure-boot.nix
    # ../common/plymouth.nix
    ../common/nix-settings.nix
    ../common/locale-sg.nix
    ../common/gnome.nix
    ../common/chinese-input.nix
    ../common/windows-fonts.nix
    ../common/cloudflare-warp.nix
    ../common/ios-usb.nix
    ../common/create-users.nix
  ];

  createUsers.jeslinmx = {
    description = "Jeshua Lin";
    extraGroups = [ "wheel" "scanner" "lp" ];
  };

  ### BOOT CUSTOMIZATION ###
  boot.loader = {
    timeout = 0;
    efi.canTouchEfiVariables = true;
    systemd-boot.netbootxyz.enable = true;
  };

  ### ENVIRONMENT CUSTOMIZATION ###
  services.flatpak.enable = true;
  virtualisation.libvirtd.enable = true;
  environment.sessionVariables = { GDK_SCALE = "1.5"; };
}
