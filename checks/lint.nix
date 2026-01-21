{
  inputs,
  system,
  ...
}:
inputs.git-hooks.lib.${system}.run {
  src = ../.;
  hooks = {
    deadnix.enable = true;
    nixfmt.enable = true;
    end-of-file-fixer.enable = true;
  };
}
