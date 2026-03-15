{ pkgs, ... }:

let
  vsMarketplace = pkgs.nix-vscode-extensions.vscode-marketplace;
in
{
  home.packages = with pkgs; [
    nixd
    nixfmt
  ];

  programs.vscode.extensions = with vsMarketplace; [
    jnoortheen.nix-ide
    io-github-oops418.nix-env-picker
  ];

  programs.vscode.profiles."default".userSettings = {
    nixEnvPicker.envFile = "flake.nix";
    nixEnvPicker.terminalAutoActivate = true;
    nixEnvPicker.terminalActivateCommand = "nix develop";

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

    "[nix]" = {
      editor.tabSize = 2;
      editor.insertSpaces = true;
    };
  };
}
