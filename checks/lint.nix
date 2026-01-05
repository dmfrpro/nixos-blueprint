{
  inputs,
  system,
  ...
}:
inputs.git-hooks.lib.${system}.run {
  src = ../.;
  hooks = {
    deadnix.enable = true;
    nixfmt-rfc-style.enable = true;
    end-of-file-fixer.enable = true;
  };
}
