{ ... }:

{
  services.libinput = {
    enable = true;
    touchpad.disableWhileTyping = true;
    mouse.disableWhileTyping = true;
  };
}
