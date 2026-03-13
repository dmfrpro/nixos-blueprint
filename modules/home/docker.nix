{ pkgs, ... }:

{
  home.packages = with pkgs; [
    docker
    docker-credential-helpers
  ];

  programs.lazydocker = {
    enable = true;
    settings = {
      customCommands = {
        containers = [
          {
            name = "bash";
            attach = true;
            command = "docker exec -it {{ .Container.ID }} bash";
            serviceNames = [ ];
          }
          {
            name = "sh";
            attach = true;
            command = "docker exec -it {{ .Container.ID }} sh";
            serviceNames = [ ];
          }
        ];
      };
    };
  };
}
