{ inputs, pkgs, ... }:

let
  kernel = pkgs.cachyosKernels.linux-cachyos-latest.override {
    processorOpt = "x86_64-v4";
    lto = "thin";
    cpusched = "bore";
    bbr3 = true;
    acpiCall = true;

    extraConfig = ''
      ASUS_ARMOURY m
    '';
  };

  helpers = pkgs.callPackage "${inputs.cachyos-kernel.outPath}/helpers.nix" { };
  kernelPackagesWithLTOFix = helpers.kernelModuleLLVMOverride (pkgs.linuxKernel.packagesFor kernel);
in
{
  imports = [
    inputs.kamakiri.nixosModules.default
  ];

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
