{ lib, ... }:

let
  keymap = mode: key: action: [ { inherit mode key action; } ];
  keymaps =
    modes: key: action:
    map (mode: { inherit mode key action; }) modes;
in
{
  # Collection of various small independent plugins/modules
  # https://nix-community.github.io/nixvim/plugins/mini.html
  plugins.mini = {
    enable = true;

    modules = {
      # Add/delete/replace surroundings (brackets, quotes, etc.)
      #
      # Examples:
      #  - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
      #  - sd'   - [S]urround [D]elete [']quotes
      #  - sr)'  - [S]urround [R]eplace [)] [']
      surround = { };

      starter = {
        items.__raw = ''
          {
            require("mini.starter").sections.recent_files(5, false, false),
            require("mini.starter").sections.builtin_actions,
          }
        '';
        footer = "";
      };

      files = { };

      # ... and there is more!
      # Check out: https://github.com/echasnovski/mini.nvim
    };
  };

  keymaps = lib.mkMerge [
    (keymap "n" "à" "<cmd>lua MiniFiles.open()<CR>")
    (keymap "n" "<C-à>" "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>")
  ];
}
