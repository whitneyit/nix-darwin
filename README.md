### TODO:

1. [x] Ensure `ssl-cert-file = /etc/nix/ca_cert.pem` is set correctly in `/etc/nix/nix.conf`
1. [ ] Download Chrome
1. [ ] Set default browser to Chrome
1. [ ] Set display to "More Space"
1. [ ] Set shortcuts in sidebar of Finder
1. [ ] Set Trackpad to tap for left and right click
1. [ ] Set display to more space
1. [ ] Set language to en-AU
1. [ ] Set date and time formats.
1. [ ] Show 24-hour time on Lock Screen.
1. [ ] Set up Touch-ID
1. [x] Change Caps-Lock key to Escape
1. [ ] Create a global `nix.conf` for all platforms.
1. [ ] Set screensaver and screensaver timeout
1. [ ] Customise touchbar
1. [ ] Set buttons to be tab-able
1. [ ] Use F1-F12 keys

### Manual Steps

1. Set wallpaper to Solid Black Colour
1. Install [Rosetta](https://en.wikipedia.org/wiki/Rosetta_software) which enables the system to run binaries for Intel CPUs transparently.

```sh
softwareupdate --install-rosetta --agree-to-license
```

### Help

<details>
<summary>How the flake was added?</summary>

```sh
mkdir -p ~/.config/nix-darwin
cd ~/.config/nix-darwin
nix flake init -t nix-darwin
sed -i '' "s/simple/$(scutil --get LocalHostName)/" flake.nix
```

</details>

### Errors:

| Name                                                     | Fix                                                              |
|:-------------------------------------------------------- |:---------------------------------------------------------------- |
| `SSL peer certificate or SSH remote key was not OK (60)` | https://github.com/NixOS/nix/issues/8081#issuecomment-1962419263 |
