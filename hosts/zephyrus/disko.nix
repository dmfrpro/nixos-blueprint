{
  disko.devices = {
    disk.main = {
      device = "/dev/disk/by-id/nvme-Samsung_SSD_990_PRO_2TB_S7DNNJ0X209853B";
      type = "disk";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            end = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = [ "umask=0077" ];
              extraArgs = [
                "-n"
                "NIXBOOT"
              ];
            };
          };

          plainSwap = {
            size = "32G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };

          luks = {
            size = "100%";

            content = {
              type = "luks";
              name = "crypted";

              settings = {
                allowDiscards = true;
                crypttabExtraOpts = [
                  "tpm2-device=auto"
                ];
              };

              content = {
                type = "filesystem";
                format = "xfs";
                mountpoint = "/";
                extraArgs = [
                  "-L"
                  "NIXROOT"
                ];
              };
            };
          };
        };
      };
    };
  };
}
