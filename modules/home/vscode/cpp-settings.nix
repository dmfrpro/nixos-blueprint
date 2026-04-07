{ pkgs, vsPkgs, ... }:

let
  checkpatch-pl = "${pkgs.nur.repos.dmfrpro.checkpatch}";
in
{
  home.packages = with pkgs; [
    clang-tools
    checkpatch-pl
  ];

  programs.vscode.extensions = with vsPkgs; [
    llvm-vs-code-extensions.vscode-clangd
    ms-vscode.cmake-tools
    ms-vscode.makefile-tools
    ajshort.include-autocomplete
    ionutvmi.path-autocomplete
    idanp.checkpatch
  ];

  programs.vscode.profiles."default".userSettings = {
    checkpatch.run = "onSave";
    checkpatch.checkpatchPath = "${checkpatch-pl}/bin/checkpatch.pl";
    checkpatch.diagnosticLevel = "Warning";

    "[c]" = {
      editor.tabSize = 8;
      editor.insertSpaces = false;
    };
    "[cpp]" = {
      editor.tabSize = 8;
      editor.insertSpaces = false;
    };
  };
}
