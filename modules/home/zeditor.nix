{ pkgs, perSystem, ... }:

{
  home.packages = with pkgs; [
    perSystem.kimi-code.kimi-cli
    clang-tools
  ];

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "make"
      "neocmake"

      "xml"
      "toml"
      "html"
      "json5"
    ];

    userSettings = {
      "agent_servers" = {
        "Kimi Code CLI" = {
          "type" = "custom";
          "command" = "kimi";
          "args" = [ "acp" ];
          "env" = { };
        };
      };
      "auto_update" = false;
      "telemetry" = {
        "diagnostics" = false;
        "metrics" = false;
      };
      "cli_default_open_behavior" = "new_window";
      "autosave" = {
        "after_delay" = {
          "milliseconds" = 1000;
        };
      };
      "theme" = "Gruvbox Dark Hard";
      "session" = {
        "trust_all_worktrees" = true;
      };
      "base_keymap" = "JetBrains";
      "theme_overrides" = {
        "Gruvbox Dark Hard" = {
          "accents" = [
            "#cc241dff"
            "#98971aff"
            "#d79921ff"
            "#458588ff"
            "#b16286ff"
            "#689d6aff"
            "#d65d0eff"
          ];
          "elevated_surface.background" = "#000000FF";
          "surface.background" = "#000000FF";
          "background" = "#000000FF";
          "status_bar.background" = "#000000FF";
          "title_bar.background" = "#000000FF";
          "toolbar.background" = "#000000FF";
          "tab_bar.background" = "#000000FF";
          "tab.inactive_background" = "#000000FF";
          "tab.active_background" = "#000000FF";
          "panel.background" = "#000000FF";
          "editor.background" = "#000000FF";
          "editor.gutter.background" = "#000000FF";
          "editor.subheader.background" = "#000000FF";
          "editor.highlighted_line.background" = "#000000FF";
          "terminal.background" = "#000000FF";
          "panel.overlay_background" = "#000000FF";
          "panel.overlay_hover" = "#000000FF";
        };
      };
    };
  };
}
