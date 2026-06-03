{ ... }:

{
  # luasnip stays: it's the snippet engine, and your ./luasnippets live here.
  # blink.cmp consumes it via snippets.preset = "luasnip" below.
  plugins.lazydev.enable = true;
  plugins.luasnip = {
    enable = true;
    settings = {
      enable_autosnippets = true;
    };
    fromLua = [
      { paths = ./luasnippets; }
    ];
  };

  # Autocompletion
  # https://nix-community.github.io/nixvim/plugins/blink-cmp/
  plugins.blink-cmp = {
    enable = true;
    # setupLspCapabilities defaults to true, so blink replaces cmp-nvim-lsp.

    settings = {
      snippets.preset = "luasnip";

      # preset "none" binds nothing unless listed here, reproducing the
      # previous nvim-cmp mappings exactly.
      keymap = {
        preset = "none";
        "<C-b>" = [
          "scroll_documentation_up"
          "fallback"
        ];
        "<C-f>" = [
          "scroll_documentation_down"
          "fallback"
        ];
        "<Tab>" = [
          "select_and_accept"
          "fallback"
        ];
        "<C-j>" = [
          "select_next"
          "fallback"
        ];
        "<C-k>" = [
          "select_prev"
          "fallback"
        ];
      };

      completion = {
        # noinsert + always-show-menu, matching the old "menu,menuone,noinsert"
        list.selection = {
          preselect = true;
          auto_insert = false;
        };

        menu.border = "rounded";
        documentation = {
          auto_show = true;
          window.border = "rounded";
        };
      };

      # Replaces the cmp-nvim-lsp-signature-help source.
      signature = {
        enabled = true;
        window.border = "rounded";
      };

      sources = {
        default = [
          "lsp"
          "path"
          "snippets"
          "lazydev"
        ];
        providers = {
          lazydev = {
            name = "LazyDev";
            module = "lazydev.integrations.blink";
            # rank above lsp, like group_index = 0 did in nvim-cmp
            score_offset = 100;
          };
        };
      };
    };
  };
}
