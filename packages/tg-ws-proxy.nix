{ pkgs, ... }:

let
  python = pkgs.python313;
  pythonPackages = python.pkgs;

  cryptography_46_0_5 = pythonPackages.cryptography.overridePythonAttrs (old: {
    version = "46.0.5";
    src = pkgs.fetchPypi {
      pname = "cryptography";
      version = "46.0.5";
      hash = "sha256-q6zkmSRyaON1cnGy8eJEs2sG+FFc8nxNSUaPyesW6T0=";
    };
    doCheck = false;
  });

  customPythonPackages = pythonPackages.overrideScope (
    self: super: {
      cryptography = cryptography_46_0_5;
    }
  );

in
customPythonPackages.buildPythonPackage rec {
  pname = "tg-ws-proxy";
  version = "1.2.1";

  src = pkgs.fetchFromGitHub {
    owner = "Flowseal";
    repo = "tg-ws-proxy";
    rev = "v${version}";
    hash = "sha256-Nn++XRWDlzlB+0DO9rzDSmHiiA9DzVgnUOCD7S0bk0Y=";
  };

  format = "pyproject";

  build-system = with customPythonPackages; [ setuptools ];

  dependencies = with customPythonPackages; [
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
