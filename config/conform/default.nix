{ pkgs, lib, ... }:

{
  extraPackages = with pkgs; [
    shellcheck
    shellharden
    shfmt

    prettierd

    fourmolu
    stylua
    nixfmt-rfc-style
    rustfmt
    ruff
    stylish-haskell
    texlivePackages.latexindent

    typstyle

    fixjson
    yamlfmt

    mdformat
  ];

  # Autoformat
  # https://nix-community.github.io/nixvim/plugins/conform-nvim.html
  plugins.conform-nvim = {
    enable = true;
    settings = {
      notify_on_error = true;
      # format_on_save = ''
      #   function(bufnr)
      #     -- Disable "format_on_save lsp_fallback" for lanuages that don't
      #     -- have a well standardized coding style. You can add additional
      #     -- lanuages here or re-enable it for the disabled ones.
      #     local disable_filetypes = { c = true, cpp = true }
      #     return {
      #       timeout_ms = 500,
      #       lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype]
      #     }
      #   end
      # '';
      formatters_by_ft = {
        sh = [
          "shellcheck"
          "shellharden"
          "shfmt"
        ];
        lua = [ "stylua" ];
        nix = [ "nixfmt" ];
        rust = [ "rustfmt" ];
        python = [ "ruff_format" ];
        haskell = [
          "fourmolu"
          "stylish-haskell"
        ];
        tex = [ "latexindent" ];
        typst = [ "typstyle" ];

        json = [ "fixjson" ];
        yaml = [ "yamlfmt" ];

        javascript = [ "prettierd" ];
        typescript = [ "prettierd" ];
        css = [ "prettierd" ];
        scss = [ "prettierd" ];
        html = [ "prettierd" ];
        markdown = [ "prettierd" ];

        "_" = [
          "squeeze_blanks"
          "trim_whitespace"
          "trim_newlines"
        ];
      };
      formatters = {
        # shellcheck = {
        #   command = lib.getExe pkgs.shellcheck;
        # };
        # shfmt = {
        #   command = lib.getExe pkgs.shfmt;
        # };
        # shellharden = {
        #   command = lib.getExe pkgs.shellharden;
        # };
        prettierd = {
          env = {
            PRETTIERD_DEFAULT_CONFIG = ./config/.prettierrc.json;
          };
        };
        latexindent = {
          args = [
            "-m"
            "-y"
            "modifyLineBreaks:textWrapOptions:columns:80"
          ];
        };
        squeeze_blanks = {
          command = lib.getExe' pkgs.coreutils "cat";
        };
      };
    };
  };

  # https://nix-community.github.io/nixvim/keymaps/index.html
  keymaps = [
    {
      mode = "";
      key = "<leader>f";
      action.__raw = # Lua
        ''
          function()
              require('conform').format { async = false, lsp_fallback = true }
              vim.cmd.w()
          end
        '';
      options = {
        desc = "[F]ormat buffer";
      };
    }
  ];
}
