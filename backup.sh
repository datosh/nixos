#!/usr/bin/env bash

# NixOS

cp /etc/nixos/configuration.nix nixos/configuration.nix
cp /etc/nixos/hardware-configuration.nix nixos/hardware-configuration.nix
cp /etc/nixos/home-manager.nix nixos/home-manager.nix
cp /etc/nixos/wallpaper.jpg nixos/wallpaper.jpg
cp -r /etc/nixos/nord-theme nixos/nord-theme

# Hyprland

cp $HOME/.config/hypr/hyprland.conf hyprland/hyprland.conf
