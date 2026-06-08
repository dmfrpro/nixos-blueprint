{
  description = "Blueprint-based Nix configuration";

  nixConfig = {
    substituters = [
      "https://mirror.yandex.ru/nixos"
      "https://nix-community.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs?ref=nixos-unstable";

    blueprint.url = "github:numtide/blueprint";
    blueprint.inputs.nixpkgs.follows = "nixpkgs";

    cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    cachyos-kernel.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";

    git-hooks.url = "github:cachix/git-hooks.nix";
    git-hooks.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    i915-sriov.url = "github:strongtz/i915-sriov-dkms";
    i915-sriov.inputs.nixpkgs.follows = "nixpkgs";

    intel-lpmd.url = "github:dmfrpro/intel-lpmd-flake";
    intel-lpmd.inputs.nixpkgs.follows = "nixpkgs";

    kimi-code.url = "github:MoonshotAI/kimi-cli";
    kimi-code.inputs.nixpkgs.follows = "nixpkgs";

    proxy-suite.url = "github:FUFSoB/proxy-suite-flake";
    proxy-suite.inputs.nixpkgs.follows = "nixpkgs";

    nixcord.url = "github:FlameFlag/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";

    zen-browser.url = "github:0xc000022070/zen-browser-flake";
    zen-browser.inputs.nixpkgs.follows = "nixpkgs";
    zen-browser.inputs.home-manager.follows = "home-manager";
  };

  outputs =
    inputs:
    inputs.blueprint {
      inherit inputs;
      nixpkgs.config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };
    };
}
