{ inputs, ... }:

{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  programs.nixcord = {
    enable = true;
    vesktop.enable = true;

    config = {
      autoUpdate = false;
      autoUpdateNotification = false;

      frameless = true;
      useQuickCss = true;
      themeLinks = [
        "https://luckfire.github.io/amoled-cord/src/amoled-cord.css"
      ];

      plugins = {
        readAllNotificationsButton.enable = true;
        noProfileThemes.enable = true;

        youtubeAdblock.enable = true;
        fixYoutubeEmbeds.enable = true;
        ClearURLs.enable = true;

        fakeNitro = {
          enable = true;
          enableEmojiBypass = true;
          enableStickerBypass = true;
          enableStreamQualityBypass = true;
          disableEmbedPermissionCheck = true;
        };

        alwaysTrust = {
          enable = true;
          confirmModal = false;
        };

        fixImagesQuality = {
          enable = true;
          originalImagesInChat = true;
        };

        betterSessions.enable = true;
        betterUploadButton.enable = true;
        betterSettings.enable = true;
        betterFolders.enable = true;
        betterGifPicker.enable = true;

        silentTyping.enable = true;
        messageClickActions.enable = true;
        OnePingPerDM.enable = true;

        validReply.enable = true;
        validUser.enable = true;

        fullSearchContext.enable = true;
        reverseImageSearch.enable = true;
      };
    };
  };
}
