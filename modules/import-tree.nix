{ lib, ... }:
{
  flake-file.inputs.import-tree.url = lib.mkForce "github:denful/import-tree";
}
