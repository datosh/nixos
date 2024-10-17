# NixOS

## Channels

Initially add unstable channel.

```sh
sudo nix-channel --add https://nixos.org/channels/nixos-unstable nixos
```

Update the channel and see new generation.

```sh
sudo nix-channel --update
# This will generate a new generation
sudo nix-channel --list-generations
```

Rollback in case of issues.

```sh
sudo nix-channel --rollback 3
```


## References

Inspired by:

* https://github.com/nomadics9/NixOS-Flake/blob/main/modules/home/pkgs/waybar.nix
* https://github.com/gvolpe/nix-config/blob/4e0f22a79c359bf12be30d938ee8e515f4ad2597/home/programs/hyprpaper/default.nix
