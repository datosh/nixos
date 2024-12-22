# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Home manager stuff
      ./home-manager.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;

  networking.hostName = "bingo";
  networking.networkmanager.enable = true;

  # Localization
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };
  console.keyMap = "de-latin1-nodeadkeys";

  # fonts.packages = with pkgs; [
  #   (nerdfonts.override { fonts = [ "FiraCode" ]; })
  # ];

  fonts.packages = with pkgs; [
    pkgs.nerd-fonts.fira-code
  ];

  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.datosh = {
    isNormalUser = true;
    description = "datosh";
    shell = pkgs.zsh;
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio" "sound" "video"
      "docker"
    ];
    packages = with pkgs; [
      neofetch
      obsidian
      gcc
      libgcc
      gnumake
      cmake
      go
      vim
      nodejs_20
      tenv
      opentofu
      google-cloud-sdk
      # Yarn
      corepack

      # browser
      firefox
      google-chrome

      # recording
      obs-studio

      # random
      libsecret
      hugo
      signal-desktop

      # hyprland
      brightnessctl   # screen brightness control
      swww
      pavucontrol     # audio volume control
      swaylock-effects swayidle wlogout
      xdg-utils       # e.g. launch browser from other apps for login
    ];
  };

  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
  #  wget
  ];

  # Audio setup
  # https://nixos.wiki/wiki/PipeWire
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # Required by VSCode to securely store tokens
  # https://nixos.wiki/wiki/Visual_Studio_Code#Error_after_Sign_On
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.sddm.enableGnomeKeyring = true;

  # display manager & compositor
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  # TODO: Move this to home manager and migrate hyprland.conf to nix
  programs.hyprland.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
