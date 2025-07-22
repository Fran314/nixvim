{
  plugins = {
    treesitter = {
      enable = true;

      settings = {
        # TODO: Don't think I need this as nixGrammars is true which should auto install these???
        # ensureInstalled = [
        #   "bash"
        #   "c"
        #   "diff"
        #   "html"
        #   "lua"
        #   "luadoc"
        #   "markdown"
        #   "markdown_inline"
        #   "query"
        #   "vim"
        #   "vimdoc"
        # ];

        highlight = {
          enable = true;

          # Some languages depend on vim's regex highlighting system (such as Ruby) for indent rules.
          # additional_vim_regex_highlighting = true;
        };

        incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<c-space>";
            node_incremental = "<c-space>";
            scope_incremental = "<c-s>";
            node_decremental = "<c-backspace>";
          };
        };

        indent = {
          enable = true;
          disable = [
            "ruby"
          ];
        };

        # There are additional nvim-treesitter modules that you can use to interact
        # with nvim-treesitter. You should go explore a few and see what interests you:
        #
        #    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
        #    - Show your current context: https://nix-community.github.io/nixvim/plugins/treesitter-context/index.html
        #    - Treesitter + textobjects: https://nix-community.github.io/nixvim/plugins/treesitter-textobjects/index.html
      };
    };
  };
}
