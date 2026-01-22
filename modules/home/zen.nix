{
  pkgs,
  inputs,
  ...
}:

let
  addons = inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system};
  flakeIcon = "share/icons/hicolor/scalable/apps/nix-snowflake.svg";
  nixSnowflakeIcon = "${pkgs.nixos-icons}/${flakeIcon}";
in
{
  programs.zen-browser = {
    enable = true;

    nativeMessagingHosts = [
      pkgs.firefoxpwa
    ];

    policies = {
      AutofillAddressEnabled = true;
      AutofillCreditCardEnabled = false;
      DisableAppUpdate = true;
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DontCheckDefaultBrowser = true;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };

    profiles.default = {
      settings = {
        browser.tabs.allow_transparent_browser = false;
        zen.widget.linux.transparency = false;
        zen.view.use-deprecated-urlbar = true;
      };

      extensions.packages = with addons; [
        # Ad-blocking
        ublock-origin
        privacy-badger
        duckduckgo-privacy-essentials

        # Google
        better-darker-docs
        dont-track-me-google1

        # Youtube
        sponsorblock
        return-youtube-dislikes
        youtube-no-translation
        youtube-high-definition
        youtube-nonstop
      ];

      mods = [
        "72f8f48d-86b9-4487-acea-eb4977b18f21" # Better ctrlTab
        "4ab93b88-151c-451b-a1b7-a1e0e28fa7f8" # No sidebar scrollbar
        "dbe05f83-b471-4278-a3f9-e5ed244b0d6c" # Old navigation buttons
        "d8b79d4a-6cba-4495-9ff6-d6d30b0e94fe" # Better active tab
        "b51ff956-6aea-47ab-80c7-d6c047c0d510" # Disable status bar
        "6f11c932-b992-433e-8c80-56a613cc511e" # Left close button
        "a5f6a231-e3c8-4ce8-8a8e-3e93efd6adec" # Cleaned URL bar
        "e122b5d9-d385-4bf8-9971-e137809097d0" # No top sites
      ];

      search = {
        force = true;
        default = "google";

        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "type";
                    value = "packages";
                  }
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = nixSnowflakeIcon;
            definedAliases = [ "p" ];
          };

          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = nixSnowflakeIcon;
            definedAliases = [ "o" ];
          };

          "Home Manager Options" = {
            urls = [
              {
                template = "https://home-manager-options.extranix.com";
                params = [
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                  {
                    name = "release";
                    value = "master";
                  }
                ];
              }
            ];
            icon = nixSnowflakeIcon;
            definedAliases = [ "hm" ];
          };
        };
      };
    };
  };

  xdg.mimeApps =
    let
      associations = builtins.listToAttrs (
        map
          (name: {
            inherit name;
            value = "zen-twilight.desktop";
          })
          [
            "application/x-extension-shtml"
            "application/x-extension-xhtml"
            "application/x-extension-html"
            "application/x-extension-xht"
            "application/x-extension-htm"
            "x-scheme-handler/unknown"
            "x-scheme-handler/mailto"
            "x-scheme-handler/chrome"
            "x-scheme-handler/about"
            "x-scheme-handler/https"
            "x-scheme-handler/http"
            "application/xhtml+xml"
            "application/json"
            "text/plain"
            "text/html"
          ]
      );
    in
    {
      enable = true;
      associations.added = associations;
      defaultApplications = associations;
    };

  xdg.configFile."mimeapps.list".force = true;
}
