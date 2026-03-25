{ ... }:

{
  services.udev.extraHwdb = ''
    evdev:name:*:dmi:bvn*:bvr*:bd*:svnASUS*:pn*:*
      KEYBOARD_KEY_ff31007c=f20    # fixes mic mute button
      KEYBOARD_KEY_ff3100b2=home   # Set fn+LeftArrow as Home
      KEYBOARD_KEY_ff3100b3=end    # Set fn+RightArrow as End
  '';

  services.logind.settings.Login = {
    LidSwitch = "suspend-then-hibernate";
    PowerKey = "hibernate";
    PowerKeyLongPress = "poweroff";
  };
}
