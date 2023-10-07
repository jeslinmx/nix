{ pkgs, unstable, ... }: {
  nixpkgs.config.allowUnfree = true;
  home = {
    username = "jeslinmx";
    homeDirectory = "/home/jeslinmx";
    stateVersion = "23.05";
  };
  xdg.enable = true;
  systemd.user.sessionVariables = {
    GDK_SCALE = "1.5";
  };
  gtk = {
    enable = true;
    theme = {
      name = "Catppuccin-Mocha-Compact-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        variant = "mocha";
        accents = [ "blue" ];
        size = "compact";
        tweaks = [ "normal" ];
      };
    };
    iconTheme = {
      name = "Colloid-nord";
      package = pkgs.colloid-icon-theme.override {
        schemeVariants = [ "nord" ];
      };
    };
  };
  services.syncthing = {
    enable = true;
    tray.enable = true;
  };
  home.packages = with pkgs; [
    ### ESSENTIALS ###
    home-manager
    starship
    unstable.chezmoi
    neofetch
    ripgrep
    fzf
    gcc
    desktop-file-utils

    ### CLI TOOLS ###
    vim
    up
    btop
    ncdu
    kjv
    wl-clipboard
    lazygit

    ### GNOME ###
    gjs
    gnome.dconf-editor
    gnome-extension-manager
    gnome.file-roller
    gnome.simple-scan
    gnome.gnome-software

    ### GRAPHICAL ###
    unstable.vivaldi
    kitty
  ];

  # programs.kitty.enable = true;
}
