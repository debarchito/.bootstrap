{ lib, inputs, ... }:
{
  flake-file.inputs.flake-file.url = lib.mkForce "github:denful/flake-file";

  imports = [
    inputs.flake-file.flakeModules.dendritic
  ];
}
