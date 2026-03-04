{
  pkgs,
  deviceId ? "0x7d55",
  ...
}:

let
  vfio-bind = pkgs.writeShellScriptBin "vfio-bind" ''
    set -euo pipefail

    echo "$kernel" > "/sys/bus/pci/devices/$kernel/driver/unbind" 2>/dev/null || true
    echo "vfio-pci" > "/sys/bus/pci/devices/$kernel/driver_override"
    modprobe vfio-pci
    echo "$kernel" > /sys/bus/pci/drivers/vfio-pci/bind
  '';

  helper = "${vfio-bind}/bin/vfio-bind";

  rule = ''
    ACTION=="add", SUBSYSTEM=="pci", KERNEL=="0000:00:02.[1-7]", \
      ATTR{vendor}=="0x8086", ATTR{device}=="${deviceId}", \
      DRIVER!="vfio-pci", RUN+="${helper}"
  '';

in
pkgs.stdenv.mkDerivation {
  pname = "i915-sriov-vf-udev-rules";
  version = "1.0";

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir -p $out/lib/udev/rules.d
    printf '%s\n' '${rule}' > $out/lib/udev/rules.d/99-i915-vf-vfio.rules
    chmod 444 $out/lib/udev/rules.d/99-i915-vf-vfio.rules
  '';

  meta = {
    license = pkgs.lib.licenses.mit;
    homepage = "https://github.com/strongtz/i915-sriov-dkms";
    sourceProvenance = [ pkgs.lib.sourceTypes.fromSource ];
    description = "Udev rule to bind i915 VFs to vfio-pci";
    platforms = [ "x86_64-linux" ];
  };
}
