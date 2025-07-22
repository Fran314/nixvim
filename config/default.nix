{
  pkgs,
  inputs,
  lib,
  ...
}:

{
  imports = [
    ./minimal.nix
    ./autowrap

    ./gitsigns
  ];

  my.options = {
    lsp.full = true;
    conform.full = true;
  };
}
