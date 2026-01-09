{
  config,
  pkgs,
  perSystem,
  ...
}:

let
  vscode-checkpatch = pkgs.callPackage ./checkpatch.nix { };
  continue-cfgdir = ".vscode/extensions/Continue.continue";
  continue-schema = "${continue-cfgdir}/config-yaml-schema.json";

  nix-settings = {
    "[nix]" = {
      editor.tabSize = 2;
      editor.insertSpaces = true;
    };

    nix.formatterPath = "${pkgs.nixfmt}/bin/nixfmt";
    nix.enableLanguageServer = true;
    nix.serverPath = "${pkgs.nixd}/bin/nixd";
  };

  clang-format-settings = {
    editor.tabSize = 8;
    editor.insertSpaces = false;
    editor.detectIndentation = false;

    C_Cpp.clang_format_fallbackStyle = "LLVM";
    C_Cpp.formatting = "clangFormat";
    C_Cpp.clang_format_path = "${pkgs.clang-tools}/bin/clang-format";
    C_Cpp.clang_format_style = "LLVM";
  };

  clang-tidy-settings = {
    C_Cpp.codeAnalysis.runAutomatically = true;
    C_Cpp.codeAnalysis.clangTidy.enabled = true;
    C_Cpp.codeAnalysis.clangTidy.path = "${pkgs.clang-tools}/bin/clang-tidy";
    C_Cpp.codeAnalysis.clangTidy.config = "";
    C_Cpp.codeAnalysis.clangTidy.fallbackConfig = ''
      { "Checks": "-*,clang-analyzer-*" }
    '';
    C_Cpp.codeAnalysis.clangTidy.useBuildPath = true;
    C_Cpp.codeAnalysis.clangTidy.showDocumentation = true;
  };

  common-c-cpp-settings = clang-format-settings // clang-tidy-settings;

  cpp-settings = {
    "[cpp]" = common-c-cpp-settings;
  };

  c-settings = {
    "[c]" = {
      checkpatch.checkpatchPath = "${perSystem.self.checkpatch-pl}/bin/checkpatch.pl";
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

    perSystem.self.checkpatch-pl
  ];

  home.file.".continue/config.yaml" = {
    text = ''
      name: Local Config
      version: 1.0.0
      schema: v1
      models:
        - name: Qwen-Coder
          provider: ollama
          model: qwen2.5-coder:14b
          roles:
            - chat
    '';
  };

  programs.vscode = {
    enable = true;
    mutableExtensionsDir = true;

    profiles."default" = {
      enableMcpIntegration = true;
      enableUpdateCheck = false;
    };

    # FIXME: https://github.com/nix-community/home-manager/issues/7880
    extensions = with pkgs.vscode-extensions; [
      # AI
      continue.continue

      # C/C++
      ms-vscode.cpptools
      ms-vscode.cmake-tools
      ms-vscode.makefile-tools

      # Checkpatch
      vscode-checkpatch

      # Git
      eamodio.gitlens
      donjayamanne.githistory

      # Nix
      oops418.nix-env-picker
      jnoortheen.nix-ide

      # JSON / YAML / XML
      redhat.vscode-xml
      redhat.vscode-yaml
    ];

    userSettings = {
      # AI
      "yaml.schemas" = {
        "file://${config.home.homeDirectory}/${continue-schema}" = [
          ".continue/**/*.yaml"
        ];
      };
      continue.telemetryEnabled = false;

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
    }
    // nix-settings
    // cpp-settings
    // c-settings;
  };
}
