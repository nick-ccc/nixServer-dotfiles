{ lib, role, ... }:

{
  assertions = [
    {
      assertion = role == "server" || role == "agent";
      message = "role must be server or agent";
    }
  ];

  imports = [
    (if role == "server"
     then ./server/server.nix
     else ./agent/agent.nix)
  ];
}
