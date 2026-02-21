{ pkgs, perSystem, ... }:

let
  dmfrproPkgs = with pkgs.nur.repos.dmfrpro; [
    spflashtool5
    spflashtool6
    rkflashtool
    upgrade_tool
  ];

  frostixPkgs = with perSystem.frostix; [
    lkpatcher
    magiskboot
    mtkclient-git
  ];
in
{
  home.packages =
    with pkgs;
    [
      android-tools
      picocom
      perSystem.penumbra.default
    ]
    ++ dmfrproPkgs
    ++ frostixPkgs;
}
