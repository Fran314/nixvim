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
    (keymaps [ "n" "i" ] "<C-S-h>" "<cmd>BufferMovePrevious<CR>")
    (keymaps [ "n" "i" ] "<C-S-l>" "<cmd>BufferMoveNext<CR>")
    (keymaps [ "n" "i" ] "<C-S-j>" "<cmd>BufferClose<CR>")
  ];
}
