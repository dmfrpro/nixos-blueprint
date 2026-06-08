{ inputs, pkgs, ... }:

let
  kernel = pkgs.cachyosKernels.linux-cachyos-latest-lto-x86_64-v4;
  helpers = pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { };
  kernelPackagesWithLTOFix = helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
in
{
  nixpkgs.overlays = [
    inputs.cachyos-kernel.overlays.default
  ];

  boot = {
    kernelPackages = kernelPackagesWithLTOFix;

    kernelModules = [
      "nvme"
      "cryptd"
      "aesni_intel"
      "kvm-intel"
    ];

    kernelParams = [
      "quiet"
      "rhgb"
      "nowatchdog"
      "nvme_load=YES"
    ];
  };
}
