{ pkgs, ... }:

let
  vsMarketplace = pkgs.nix-vscode-extensions.vscode-marketplace;
in
{
  imports = [
    ./cpp-settings.nix
    ./nix-settings.nix
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles."default" = {
      enableUpdateCheck = false;
    };

    extensions = with vsMarketplace; [
      vscode-icons-team.vscode-icons
    ];

    profiles."default".userSettings = {
      workbench.colorTheme = "Experimental Dark";
      workbench.iconTheme = "vscode-icons";
      "update.mode" = "none";

      chat.disableAIFeatures = true;

      "editor.formatOnSave" = true;
      "editor.formatOnPaste" = true;
      "editor.formatOnSaveMode" = "modificationsIfAvaliable";
      "editor.minimap.enabled" = false;
      "editor.cursorStyle" = "line";
      "editor.fontFamily" = "Fira Code, monospace";
      "editor.fontSize" = 14;
      "editor.lineHeight" = 1.5;
      "editor.wordWrap" = "on";
      "editor.letterSpacing" = 0.5;

      files.autoSave = "afterDelay";
    };
  };
}
