{ inputs, ... }:

{
  imports = [
    inputs.intel-lpmd.nixosModules.default
  ];

  services.intel-lpmd = {
    enable = true;
    config.meteorLake = true;
    mode = "ON";
  };
}
