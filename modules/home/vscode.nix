{ pkgs, ... }:

let
  vsPkgs = pkgs.nix-vscode-extensions.vscode-marketplace;
  checkpatch-pl = "${pkgs.nur.repos.dmfrpro.checkpatch}";
in
{
  home.packages = with pkgs; [
    # Nix
    nixd
    nixfmt

    # Shell
    shellcheck
    shfmt

    # Cpp
    clang-tools
    checkpatch-pl
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = false;

    profiles."default" = {
      enableUpdateCheck = false;
    };

    extensions = with vsPkgs; [
      vscode-icons-team.vscode-icons

      # Nix
      jnoortheen.nix-ide
      arrterian.nix-env-selector

      # Just
      nefrob.vscode-just-syntax

      # RPM
      rvsmartporting.rpm-spec-ext

      # Shell
      mkhl.direnv
      mads-hartmann.bash-ide-vscode

      # Cpp
      llvm-vs-code-extensions.vscode-clangd
      ms-vscode.cmake-tools
      ms-vscode.makefile-tools
      ajshort.include-autocomplete
      ionutvmi.path-autocomplete
      idanp.checkpatch
    ];

    profiles."default".userSettings = {
      workbench.colorTheme = "Experimental Dark";
      workbench.iconTheme = "vscode-icons";
      "update.mode" = "none";

      chat.disableAIFeatures = true;

      editor.formatOnSave = true;
      editor.formatOnPaste = true;
      editor.formatOnSaveMode = "modificationsIfAvaliable";
      editor.minimap.enabled = false;
      editor.cursorStyle = "line";
      editor.fontFamily = "Fira Code, monospace";
      editor.fontSize = 14;
      editor.lineHeight = 1.5;
      editor.wordWrap = "on";
      editor.letterSpacing = 0.5;

      files.autoSave = "afterDelay";

      "[nix]" = {
        editor.tabSize = 2;
        editor.insertSpaces = true;
      };
      "[c]" = {
        editor.tabSize = 8;
        editor.insertSpaces = false;
      };
      "[cpp]" = {
        editor.tabSize = 4;
        editor.insertSpaces = false;
      };

      # Nix
      nixEnvSelector.useFlakes = true;
      nix.enableLanguageServer = true;
      nix.formatterPath = "${pkgs.nixfmt}/bin/nixfmt";
      nix.serverPath = "${pkgs.nixd}/bin/nixd";
      "nix.serverSettings" = {
        "nixd" = {
          "formatting" = {
            "command" = [ "nixfmt" ];
          };
        };
      };

      # Cpp
      checkpatch.run = "onSave";
      checkpatch.checkpatchPath = "${checkpatch-pl}/bin/checkpatch.pl";
      checkpatch.diagnosticLevel = "Warning";
      cmake.configureOnOpen = false;
      cmake.configureOnExit = false;
    };
  };
}
