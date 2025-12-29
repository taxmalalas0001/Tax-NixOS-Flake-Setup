{ inputs, lib, config, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.home-manager
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Latest kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Hostname
  networking.hostName = "nixos-laptop";
 
  # use Nh as system rebuilder
  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 1d --keep 3";
    flake = "/home/taxmalalas0001/nix-config";
  };

  # Enable Fish
  programs.fish.enable = true;

  # NetworkManager
  networking.networkmanager.enable = true;

  # Time zone & Greek locales
  time.timeZone = "Europe/Athens";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "el_GR.UTF-8";
    LC_IDENTIFICATION = "el_GR.UTF-8";
    LC_MEASUREMENT = "el_GR.UTF-8";
    LC_MONETARY = "el_GR.UTF-8";
    LC_NAME = "el_GR.UTF-8";
    LC_NUMERIC = "el_GR.UTF-8";
    LC_PAPER = "el_GR.UTF-8";
    LC_TELEPHONE = "el_GR.UTF-8";
    LC_TIME = "el_GR.UTF-8";
  };

  # Gnome + XWayland 
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # Make Apps Use Wayland
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Keymap
  services.xserver.xkb.layout = "us";
 
  # Enable Dynamically Linked Executables
  programs.nix-ld.enable = true;

  # Printing
  services.printing.enable = true;

  # Pipewire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Unfree packages
  nixpkgs.config.allowUnfree = true;

  # Firefox system-wide (MOVE TO HOME-MANAGER)
  programs.firefox.enable = true;

  # Disable NSCD For now Until they patch this.
  services.nscd.enable = false;
  system.nssModules = lib.mkForce [ ];

  # Flake settings
  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      flake-registry = "";
      nix-path = config.nix.nixPath;
    };
    channel.enable = false;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  # Home Manager integration
  home-manager = {
#    useGlobalPkgs = true; # Shares system pkgs
    useUserPackages = true;    # Installs user packages to user profile
    extraSpecialArgs = { inherit inputs; };
    users.taxmalalas0001 = import ../home-manager/home.nix;
  };

  users.users.taxmalalas0001 = {
    isNormalUser = true;
    description = "Taxiarchis Tsairidis";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.fish;
  };

  # Enable Flatpak
  services.flatpak.enable = true;

  # enable sdl2
  environment.systemPackages = with pkgs; [
    sdl3  # Steam Input controller resurrection
  ];

  # Graphics Acceleration
  hardware.graphics = {
    enable = true;
    enable32Bit = true;  # Good for older/32-bit games
  };
 
  # Enable Steam 
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
};
  hardware.steam-hardware.enable = true;
  services.udev.extraRules = ''
    # PS4 DualShock 4 USB (original)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666", TAG+="uaccess"

    # PS4 DualShock 4 USB (V2/slim)
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666", TAG+="uaccess"

    # PS4 DualShock 4 Bluetooth
    SUBSYSTEM=="bluetooth", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="05c4", MODE="0666", TAG+="uaccess"
    SUBSYSTEM=="bluetooth", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="09cc", MODE="0666", TAG+="uaccess"

    # PS5 DualSense USB
    SUBSYSTEM=="usb", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666", TAG+="uaccess"

    # PS5 DualSense Bluetooth
    SUBSYSTEM=="bluetooth", ATTRS{idVendor}=="054c", ATTRS{idProduct}=="0ce6", MODE="0666", TAG+="uaccess"
  '';

  services.openssh = {
    enable = false;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  system.stateVersion = "25.11";
}
