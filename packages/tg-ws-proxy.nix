{ pkgs, ... }:

let
  python = pkgs.python313;
  pythonPackages = python.pkgs;
in
pythonPackages.buildPythonPackage rec {
  pname = "tg-ws-proxy";
  version = "1.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "Flowseal";
    repo = "tg-ws-proxy";
    rev = "v${version}";
    hash = "sha256-Nn++XRWDlzlB+0DO9rzDSmHiiA9DzVgnUOCD7S0bk0Y=";
  };

  format = "pyproject";

  build-system = with pythonPackages; [ setuptools ];

  dependencies = with pythonPackages; [
    aiohttp
    aiohttp-socks
    cryptography
    appdirs
    hatchling
    customtkinter
    pillow
    psutil
    pystray
    pyperclip
  ];

  doCheck = false;

  meta = {
    description = "Local SOCKS5 proxy for Telegram using WebSocket connections";
    homepage = "https://github.com/Flowseal/tg-ws-proxy";
    license = pkgs.lib.licenses.mit;
    platforms = pkgs.lib.platforms.linux;
  };
}
