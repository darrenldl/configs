{ ... }:

{
  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  
  boot.initrd.luks.devices."luks-DUMMY0".device = "/dev/disk/by-uuid/DUMMY1";
}
