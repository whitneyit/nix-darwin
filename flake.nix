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

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment = {
        shells = [
          pkgs.zsh
        ];

        systemPackages = with pkgs; [
          neovim
          nodejs
          nodePackages.pnpm
          nodePackages.yarn
          tmux
          tree
          vim
        ];

        variables = {
          EDITOR = "vim";
          NODE_EXTRA_CA_CERTS = "/etc/nix/ca_cert.pem";
        };
      };

      fonts = {
        packages = with pkgs; [
          font-awesome
          material-design-icons

          (nerdfonts.override {
            fonts = [
              "FiraCode"
            ];
          })
        ];
      };

      programs = {
        # Enable alternative shell support in nix-darwin.
        zsh.enable = true;
      };

      # Add ability to used TouchID for sudo authentication
      security = {
        pam.enableSudoTouchIdAuth = true;
      };

      system = {
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;

        defaults = {
          controlcenter = {
            BatteryShowPercentage = true;
            Bluetooth = true;
          };

          CustomUserPreferences = {
            ".GlobalPreferences" = {
              AppleSpacesSwitchOnActivate = true;
            };
            "com.apple.AdLib" = {
              allowApplePersonalizedAdvertising = false;
            };
            "com.apple.desktopservices" = {
              DSDontWriteNetworkStores = true;
              DSDontWriteUSBStores = true;
            };
            "com.apple.finder" = {
              ShowExternalHardDrivesOnDesktop = false;
              ShowHardDrivesOnDesktop = false;
              ShowMountedServersOnDesktop = false;
              ShowRemovableMediaOnDesktop = false;
              _FXSortFoldersFirst = true;
              # When performing a search, search the current folder by default
              FXDefaultSearchScope = "SCcf";
            };
            "com.apple.ImageCapture".disableHotPlug = true;
            "com.apple.screencapture" = {
              location = "~/Pictures/Screenshots";
              type = "png";
            };
            "com.apple.screensaver" = {
              askForPassword = 1;
              askForPasswordDelay = 0;
            };
            "com.apple.spaces" = {
              "spans-displays" = 0;
            };
            "com.apple.WindowManager" = {
              EnableStandardClickToShowDesktop = 0;
              StandardHideDesktopIcons = 0;
              HideDesktop = 0;
              StageManagerHideWidgets = 0;
              StandardHideWidgets = 0;
            };
            NSGlobalDomain = {
              WebKitDeveloperExtras = true;
            };
          };

          dock = {
            autohide  = true;
            mru-spaces = false;
            persistent-apps = [
              "/System/Applications/Utilities/Terminal.app"
              "/System/Applications/System\ Settings.app/"
            ];
            show-recents = false;
          };

          finder = {
            _FXShowPosixPathInTitle = true;
            _FXSortFoldersFirst = true;
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            FXEnableExtensionChangeWarning = false;
            FXPreferredViewStyle = "clmv";
            QuitMenuItem = true;
            ShowPathbar = true;
            ShowStatusBar = true;
          };

          loginwindow = {
            DisableConsoleAccess = true;
            GuestEnabled = false;
          };

          menuExtraClock = {
            FlashDateSeparators = true;
            IsAnalog = false;
            Show24Hour = true;
            ShowAMPM = false;
            ShowDayOfMonth = true;
            ShowDayOfWeek = true;
            ShowDate = 1;
            ShowSeconds = false;
          };

          NSGlobalDomain = {
            AppleICUForce24HourTime = true;
            AppleInterfaceStyle = "Dark";
            AppleKeyboardUIMode = 3;
            ApplePressAndHoldEnabled = false;
            AppleShowAllFiles = true;
            InitialKeyRepeat = 15; # 225ms
            KeyRepeat = 2; # 30ms
            NSAutomaticCapitalizationEnabled = false;
            NSAutomaticDashSubstitutionEnabled = false;
            NSAutomaticPeriodSubstitutionEnabled = false;
            NSAutomaticQuoteSubstitutionEnabled = false;
            NSAutomaticSpellingCorrectionEnabled = false;
            NSNavPanelExpandedStateForSaveMode = true;
            NSNavPanelExpandedStateForSaveMode2 = true;
          };

          screencapture = {
            location = "~/Pictures/Screenshots";
          };

          trackpad = {
            Clicking = true;
            TrackpadRightClick = true;
          };

          WindowManager = {
            EnableStandardClickToShowDesktop = false;
          };
        };

        keyboard = {
          enableKeyMapping = true;
          remapCapsLockToEscape = true;
        };

      };

      # Set your time zone.
      time.timeZone = "Australia/Sydney";

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
