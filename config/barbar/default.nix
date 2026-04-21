{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  keymap = mode: key: action: [ { inherit mode key action; } ];
  keymaps =
    modes: key: action:
    map (mode: { inherit mode key action; }) modes;
in
{
  plugins = {
    barbar.enable = true;
  };

  keymaps = lib.mkMerge [
    (keymaps [ "n" "i" ] "<C-h>" "<cmd>BufferPrevious<CR>")
    (keymaps [ "n" "i" ] "<C-l>" "<cmd>BufferNext<CR>")
    (keymaps [ "n" "i" ] "<C-A-h>" "<cmd>BufferMovePrevious<CR>")
    (keymaps [ "n" "i" ] "<C-A-l>" "<cmd>BufferMoveNext<CR>")
    (keymaps [ "n" "i" ] "<C-A-j>" "<cmd>BufferClose<CR>")
  ];
}
