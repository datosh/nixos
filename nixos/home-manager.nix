{ config, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
    # TODO: Make this file more modular and separate into:
    # ./waybar.nix
    # ...
  ];

  home-manager.users.datosh = {
    programs.home-manager.enable = true;
    home = {
      username = "datosh";
      homeDirectory = "/home/datosh";
      stateVersion = "24.05";
      sessionPath = [
        "$HOME/go/bin"
      ];
    };

    nixpkgs.config.allowUnfree = true;

    home.packages = with pkgs; [
      # Control volume levels
      pamixer
      # Desktop wallpaper
      hyprpaper

      # Applications
      vlc
    ];

    programs.obs-studio.enable = true;

    # Configure background image
    xdg.configFile."hypr/hyprpaper.conf".text = ''
      preload=${./wallpaper.jpg}
      wallpaper=,${./wallpaper.jpg}
      ipc=off
    '';

    programs.ssh = {
      enable = true;
      matchBlocks = {
        "nonoisenode" = {
          hostname = "192.168.1.109";
          user = "datosh";
        };
      };
    };

    programs.git = {
      enable = true;
      userEmail = "fabian@kammel.dev";
      userName = "Fabian Kammel";
    };

    # TODO: Migrate the rest of my zsh config to nix syntax
    programs.zsh = {
      enable = true;
      shellAliases = {
        clean = "sudo nix-collect-garbage -d";
      };
      initExtra = "unsetopt beep";
      autosuggestion.enable = true;
      # Custom plugins get copied to $HOME/.zsh/plugins and automatically
      # sourced from .zsh file.
      plugins = [
        {
          name = "nord-theme";
          file = "nord.zsh-theme";
          src = ./nord-theme;
        }
      ];
      oh-my-zsh = {
        enable = true;
      };
    };

    programs.kitty = {
      enable = true;
      shellIntegration.enableZshIntegration = true;
      theme = "Nord";
      settings = {
        # TODO: Copy the rest of my kitty config to nix syntax
        enable_audio_bell = false;
      };
    };

    programs.vscode.enable = true;
    programs.gh.enable = true;

    # XDG portal components are required for things like file picker and
    # screen sharing. See:
    # https://wiki.hyprland.org/Useful-Utilities/xdg-desktop-portal-hyprland/
    xdg.portal = {
      enable = true;
      config = {
        common = {
          default = [ "hyprland" ];
        };
        hyprland = {
          default = [ "gtk" "hyprland" ];
        };
      };
      extraPortals = with pkgs; [
        xdg-desktop-portal-gtk
        xdg-desktop-portal-hyprland
      ];
      xdgOpenUsePortal = true;
    };

    # Launcher
    programs.wofi = {
      enable = true;
      settings = {
        "width"=900;
        "height"=350;
        "location"="center";
        "show"="drun";
        "prompt"="Search...";
        "filter_rate"=100;
        "allow_markup"=true;
        "no_actions"=true;
        "halign"="fill";
        "orientation"="vertical";
        "content_halign"="fill";
        "insensitive"=true;
        "allow_images"=true;
        "image_size"=40;
        "columns"=2;
        "matching"="fuzzy";
      };
      # TODO: Style wofi with Nord theme
      # style...
    };

    programs.waybar = {
      enable = true;
      style = ./waybar-style.css;

      settings = {
        minBar = {
          layer = "top";
          position = "top";
          height = 24;
          modules-left = ["cpu" "memory" "hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = ["network" "pulseaudio" "battery"];

          "clock" = {
            format = "{:%H:%M}";
            format-alt = "{:%b %d %Y}";
            tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          };

          "pulseaudio" = {
            format = "{volume}% {icon}";
            format-muted = "󰖁";
            format-icons = {
              default = ["󰕿" "󰖀" "󰕾"];
            };
            scroll-step = 5.0;
            smooth-scrolling-threshold = 7.0;
            on-click-right = "pamixer -t";
            on-click = "pavucontrol";
          };

          "battery" = {
            interval = 60;
            states = {
              warning = 25;
              critical = 15;
            };
            format = "{capacity}% {icon}";
            format-warning = "{icon}";
            format-critical = "{icon}";
            format-charging = "{capacity}% 󱐋";
            format-plugged = "{capacity}% 󰚥";
            format-notcharging = "{capacity}% 󰚥";
            format-full = "{capacity}% 󰂄";

            format-alt = "{capacity}%";
            format-icons = ["󱊡" "󱊢" "󱊣"];
          };

          "cpu" = {
            format = "{}% ";
            interval = 3;
          };

          "memory" = {
            format = "{}% ";
            interval = 3;
          };

          "hyprland/workspaces" = {
            format = "{name}";
            all-outputs = true;
            on-click = "activate";
            format-icons = {
              active = " 󱎴";
              default = "󰍹";
            };
          };

          "network" = {
            format-wifi = "{bandwidthUpBytes} ↑ {bandwidthDownBytes} ↓ {icon} ({signalStrength})";
            format-ethernet = "{bandwidthUpBytes} ↑ {bandwidthDownBytes} ↓ 󰈀";
            format-disconnected = "󰤭";
            tooltip-format = "{essid}";
            interval = 3;
            # on-click = "~/.config/waybar/scripts/network/rofi-network-manager.sh";
            format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
          };
        };
      };
    };
  };
}
