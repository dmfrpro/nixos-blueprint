{ pkgs, ... }:

let
  asfpNew =
    let
      mkStudio =
        opts:
        pkgs.callPackage
          (import "${pkgs.path}/pkgs/applications/editors/android-studio-for-platform/common.nix" opts)
          {
            fontsConf = pkgs.makeFontsConf { fontDirectories = [ ]; };
            inherit (pkgs) buildFHSEnv;
          };
    in
    mkStudio {
      version = "2025.3.2.6";
      versionPrefix = "Panda%202";
      sha256Hash = "sha256-mAJPmDSoE9STOh45u0dIejL4TyR8CIqcGMhiixIFIWc=";

      channel = "stable";
      pname = "android-studio-for-platform";
    };
in
{
  home.packages = [ asfpNew ];
}
