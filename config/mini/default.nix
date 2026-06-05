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

      files = {
        mappings = {
          synchronize = "ì"; # same position of the default value '=' on the italian keyboard
        };
        content.filter.__raw = ''
          function(fs_entry)
            local hidden = {
              ".git", ".svn", ".hg",
              "node_modules", ".direnv", ".venv", "venv", "__pycache__", ".bundle", "vendor",
              "dist", "build", "target", "out", ".next", ".nuxt", "result",
              ".cache", ".mypy_cache", ".pytest_cache", ".ruff_cache", ".turbo", ".parcel-cache",
              ".idea", ".vscode", ".DS_Store",
            }
            local patterns = { "%.pyc$", "%.o$" }
            if vim.tbl_contains(hidden, fs_entry.name) then return false end
            for _, p in ipairs(patterns) do
              if fs_entry.name:match(p) then return false end
            end
            return true
          end
        '';
      };
    };
  };

  keymaps = lib.mkMerge [
    (keymap "n" "à" "<cmd>lua MiniFiles.open()<CR>")
    (keymap "n" "°" "<cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>")
  ];
}
