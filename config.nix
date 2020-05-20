{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  networking.hostName = "nixos"; # Define your hostname.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;

  # Select internationalisation properties.
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "uk";
    defaultLocale = "en_GB.UTF-8";
  };

  # Set your time zone.
  time.timeZone = "Europe/London";

  # List packages installed in system profile. To search, run:
  environment.systemPackages = with pkgs; [
    (python35.withPackages(ps: with ps; [ numpy ]))
    (import /etc/nixos/builds/emacs.nix { inherit pkgs; })

    haskellPackages.Agda
    haskellPackages.ghc
    haskellPackages.cabal-install
    haskellPackages.stack

    firefox
    git
    idris
    slack
    spotify
    vim
    wget
  ];

  nixpkgs.config = {
    allowUnfree = true;
  };

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "gb";
  services.xserver.xkbOptions = "eurosign:e";

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  # Enable the KDE Desktop Environment.
  services.xserver.desktopManager.plasma5.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.edd = {
    isNormalUser = true;
    home = "/home/edd";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  # System
  system.stateVersion = "19.09"; # Did you read the comment?

}
