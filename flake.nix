{
  description = "Example nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = with pkgs; [
        neovim
        nodejs
        nodePackages.typescript
        tmux
        vim
      ];

      fonts.packages = with pkgs; [
        (nerdfonts.override { fonts = [ "FiraCode" ]; })
      ];

      system.defaults = {
        controlcenter.BatteryShowPercentage = true;
        controlcenter.Bluetooth = true;
        dock.autohide  = true;
        dock.mru-spaces = false;
        dock.persistent-apps = [
          "/System/Applications/Utilities/Terminal.app"
          "/System/Applications/System\ Settings.app/"
        ];
        finder.AppleShowAllExtensions = true;
        finder.FXPreferredViewStyle = "clmv";
        menuExtraClock.FlashDateSeparators = true;
        menuExtraClock.IsAnalog = false;
        menuExtraClock.Show24Hour = true;
        menuExtraClock.ShowAMPM = false;
        menuExtraClock.ShowDayOfMonth = true;
        menuExtraClock.ShowDayOfWeek = true;
        menuExtraClock.ShowDate = 1;
        menuExtraClock.ShowSeconds = false;
        NSGlobalDomain.AppleICUForce24HourTime = true;
        NSGlobalDomain.AppleInterfaceStyle = "Dark";
        NSGlobalDomain.AppleShowAllFiles = true;
        NSGlobalDomain.KeyRepeat = 2;
        screencapture.location = "~/Pictures/Screenshots";
        WindowManager.EnableStandardClickToShowDesktop = false;
      };

      system.keyboard.enableKeyMapping = true;
      system.keyboard.remapCapsLockToEscape = true;

      # Auto upgrade nix package and the daemon service.
      services.nix-daemon.enable = true;
      # nix.package = pkgs.nix;

      nix.extraOptions = ''
        extra-platforms = x86_64-darwin aarch64-darwin
      '';

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # https://github.com/NixOS/nix/issues/8081#issuecomment-1962419263
      nix.settings.ssl-cert-file = "/etc/nix/ca_cert.pem";

      # Enable alternative shell support in nix-darwin.
      programs.zsh.enable = true;
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      # nixpkgs.hostPlatform = "x86_64-darwin";
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#MC02HG3Z8Q05F
    darwinConfigurations."MC02HG3Z8Q05F" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."MC02HG3Z8Q05F".pkgs;
  };
}
