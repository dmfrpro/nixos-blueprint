{ pkgs, vsPkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nixfmt
  ];

  programs.vscode.extensions = with vsPkgs; [
    jnoortheen.nix-ide
    mkhl.direnv
    arrterian.nix-env-selector
    nefrob.vscode-just-syntax
  ];

  programs.vscode.profiles."default".userSettings = {
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

    "[nix]" = {
      editor.tabSize = 2;
      editor.insertSpaces = true;
    };
  };
}
