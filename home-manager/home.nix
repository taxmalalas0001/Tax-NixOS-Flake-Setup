{ config, pkgs, inputs, ... }:

{
  # Enable Home Manager to manage itself
  programs.home-manager.enable = true;

  # User packages
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
    git
    htop
    curl
    wget
    tree
    python314
    python313Packages.pip
    imagemagick
    gimp
    vlc
    kitty
    departure-mono
    sc-controller
  ] ++ [ # Hyprland Dependencies
    hyprlock
    pywal
    swww
    wofi
    grim
    font-awesome
    waybar
    dunst
  ] ++ [ # LazyVim Dependencies
    gcc
    gnumake
    nodejs
    unzip
    ripgrep
    fd
  ];

  # Flatpak configuration (package is in configuration.nix)
  xdg.enable = true;

  home.sessionVariables = {
    XDG_DATA_DIRS =
      "$HOME/.local/share/flatpak/exports/share:"
      + "/var/lib/flatpak/exports/share:"
      + "$XDG_DATA_DIRS";
  };

  # Declarative Kitty config (Orange/Orwellian Theme)
  home.file.".config/kitty" = {
    source = ../dotfiles/kitty;
    recursive = true;
  };

  # Declarative Waybar config
  home.file.".config/waybar" = {
    source = ../dotfiles/waybar;
    recursive = true;
    force = true;
    };

  # Declarative Wofi config
  home.file.".config/wofi" = {
    source = ../dotfiles/wofi;
    };

  # Declarative Hyprlock config
  home.file.".config/hypr/hyprlock.conf" = {
      source = ../dotfiles/hypr/hyprlock.conf;
    };

  # Declarative Dunst config
  home.file.".config/dunst" = {
    source = ../dotfiles/dunst;
  };

  # Declarative Hyprland config
  home.file.".config/hypr" = {
    source = ../dotfiles/hypr;
    recursive = true;
    force = true;
  };

  # Declarative Starship config
  home.file.".config/starship.toml" = {
    source = ../dotfiles/starship/starship.toml;
  };
 
  # Declaratively Include Backgrounds
  home.file.".config/backgrounds" = {
    source = ../dotfiles/backgrounds;
    recursive = true;
  };

  # Neovim With LazyVim
  programs.neovim = {
      enable = true;
      defaultEditor = true;
 };

  home.file.".config/nvim" = {
    source = ../dotfiles/nvim;
    recursive = true;
  };

  # Fish tweaks
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos-laptop";
      hmconf = "nvim ~/nix-config/home-manager/home.nix";
      flakeconf = "nvim ~/nix-config/flake.nix";
      sysconf = "nvim ~/nix-config/nixos/configuration.nix";
      gitadd = "git add .";
      gitcom = "git commit -m";
      gitpush = "git push -u origin main";
    };
    interactiveShellInit = ''
      set -g fish_greeting
    '';
  };
  programs.starship = {
    enable = true;
    enableFishIntegration = true;
  };


  # State version (IMPORTANT: match your NixOS one)
  home.stateVersion = "25.11";
}
