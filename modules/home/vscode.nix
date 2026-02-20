{
  pkgs,
  perSystem,
  ...
}:

let
  nix-settings = {
    "[nix]" = {
      editor.tabSize = 2;
      editor.insertSpaces = true;
    };

    nix.formatterPath = "${pkgs.nixfmt}/bin/nixfmt";
    nix.enableLanguageServer = true;
    nix.serverPath = "${pkgs.nixd}/bin/nixd";

    nixEnvSelector.useFlakes = true;
  };

  clang-format-settings = {
    editor.tabSize = 8;
    editor.insertSpaces = false;
    editor.detectIndentation = false;
  };

  cpp-lint-settings = {
    c-cpp-flylint.ignoreParseErrors = true;
    c-cpp-flylint.clang.enable = true;
    c-cpp-flylint.cppcheck.enable = true;

    c-cpp-flylint.flexelint.enable = false;
    c-cpp-flylint.pclintplus.enable = false;
    c-cpp-flylint.flawfinder.enable = false;
  };

  common-c-cpp-settings = clang-format-settings // cpp-lint-settings;

  cpp-settings = {
    "[cpp]" = common-c-cpp-settings;
  };

  c-settings = {
    "[c]" = {
      checkpatch.checkpatchPath = "${pkgs.nur.repos.dmfrpro.checkpatch}/bin/checkpatch.pl";
      checkpatch.run = "onSave";
    }
    // common-c-cpp-settings;
  };
in
{
  home.packages = with pkgs; [
    nixfmt
    nixd
    clang
    clang-analyzer
    clang-tools
    cppcheck
    ctags
    python313Packages.lizard
    cmake-format
    mbake
    shfmt
    
    nur.repos.dmfrpro.checkpatch
  ];

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;
    package = pkgs.vscode;

    profiles."default" = {
      enableUpdateCheck = false;
    };

    # FIXME: https://github.com/nix-community/home-manager/issues/7880
    extensions = with pkgs.nix-vscode-extensions.vscode-marketplace; [
      # C/C++
      llvm-vs-code-extensions.vscode-clangd
      ajshort.include-autocomplete
      ionutvmi.path-autocomplete
      xaver.clang-format
      jbenden.c-cpp-flylint

      # Containers
      ms-azuretools.vscode-docker
      ms-vscode-remote.remote-containers

      # ASM
      dan-c-underwood.arm
      maziac.asm-code-lens

      # Make / CMake
      ms-vscode.cmake-tools
      cheshirekow.cmake-format
      ms-vscode.makefile-tools
      eshojaei.mbake-makefile-formatter

      # Kernel
      microhobby.linuxkerneldev
      idanp.checkpatch

      # Git / Dirs
      eamodio.gitlens
      donjayamanne.githistory
      alefragnani.project-manager

      # Nix
      arrterian.nix-env-selector
      jnoortheen.nix-ide

      # JSON / YAML / XML
      redhat.vscode-xml
      redhat.vscode-yaml

      # Python
      ms-python.python

      # Shell
      mads-hartmann.bash-ide-vscode

      # Themes
      vscode-icons-team.vscode-icons
    ];

    userSettings = {
      # General settings
      editor.tabSize = 4;
      editor.formatOnSave = true;
      editor.formatOnPaste = false;
      editor.minimap.enabled = false;
      editor.cursorStyle = "line";
      editor.fontFamily = "Fira Code, monospace";
      editor.fontSize = 14;
      editor.lineHeight = 1.5;
      editor.wordWrap = "on";
      editor.letterSpacing = 0.5;
      workbench.iconTheme = "vscode-icons";
      update.mode = "none";

      files.autoSave = "afterDelay";

      # Explorer settings
      explorer.confirmBeforeDelete = false;
      explorer.showNewFile = true;
      explorer.showHiddenFiles = true;
      explorer.showFilePath = true;

      # Window settings
      window.zoomLevel = 0;
      window.openFilesInNewWindow = false;
      window.restoreWindows = "none";

      # Git settings
      git.confirmSync = false;
      git.autofetch = true;
      git.autoRevert = true;
      git.autoStash = true;
      git.untrackedChanges = "ignored";

      # Terminal settings
      terminal.integrated.fontSize = 14;
      terminal.integrated.lineHeight = 1.5;
      terminal.integrated.fontFamily = "Fira Code, monospace";
      terminal.integrated.cursorStyle = "line";
      terminal.integrated.rendererType = "webgl";

      # Debug settings
      debug.showDebugOutput = "always";
      debug.showControlBar = true;
      debug.showBreakpoints = true;
      debug.showBreakpointsInSidebar = true;
      debug.showBreakpointsInEditor = true;

      # Extensions
      extensions.sortOrder = "name";
      extensions.ignoreRecommendations = true;
      extensions.showRecommendations = false;
      extensions.showAllExtensions = false;

      # Disable built-in chat
      chat.disableAIFeatures = true;
    }
    // nix-settings
    // cpp-settings
    // c-settings;
  };
}
