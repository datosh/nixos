#!/usr/bin/env bash

# NixOS

sudo cp nixos/configuration.nix /etc/nixos/configuration.nix
sudo cp nixos/hardware-configuration.nix /etc/nixos/hardware-configuration.nix
sudo cp nixos/home-manager.nix /etc/nixos/home-manager.nix
sudo cp nixos/wallpaper.jpg /etc/nixos/wallpaper.jpg
sudo cp -r nixos/nord-theme /etc/nixos/nord-theme

# Hyprland

sudo cp hyprland/hyprland.conf $HOME/.config/hypr/hyprland.conf

sudo nixos-rebuild switch
