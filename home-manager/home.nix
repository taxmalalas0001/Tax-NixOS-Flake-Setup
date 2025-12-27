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
    kitty
    sc-controller
  ] ++ [ # LazyVim Dependencies
    gcc
    gnumake
    nodejs
    unzip
    ripgrep
    fd
  ];

  # Flatpak
  xdg.enable = true;

  home.sessionVariables = {
    XDG_DATA_DIRS =
      "$HOME/.local/share/flatpak/exports/share:"
      + "/var/lib/flatpak/exports/share:"
      + "$XDG_DATA_DIRS";
  };


  # Neovim Enable
  programs.neovim = {
      enable = true;
      defaultEditor = true;
 };

  # Fish tweaks
  programs.fish = {
    enable = true;
    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nix-config#nixos-laptop";
      hmconf = "nvim ~/nix-config/home-manager/home.nix";
      flakeconf = "nvim ~/nix-config/flake.nix";
      sysconf = "nvim ~/nix-config/nixos/configuration.nix";
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
