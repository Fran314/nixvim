{
  pkgs,
  lib,
  config,
  ...
}:

with lib;

let
  cfg = config.my.options.conform;
in
{
  options.my.options.conform = {
    full = mkEnableOption "";
  };

  config = {
    extraPackages =
      with pkgs;
      mkMerge [
        [
          shellcheck
          shellharden
          shfmt

          prettierd

          fixjson
          yamlfmt

          nixfmt-rfc-style
        ]

        (mkIf cfg.full [
          fourmolu
          stylua
          rustfmt
          ruff
          stylish-haskell
          texlivePackages.latexindent
          typstyle
        ])
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
          nix = [ "nixfmt" ];

          "_" = [
            "squeeze_blanks"
            "trim_whitespace"
            "trim_newlines"
          ];

          json = [ "fixjson" ];
          yaml = [ "yamlfmt" ];

          javascript = [ "prettierd" ];
          typescript = [ "prettierd" ];
          css = [ "prettierd" ];
          scss = [ "prettierd" ];
          html = [ "prettierd" ];
          markdown = [ "prettierd" ];

          lua = [ "stylua" ];
          rust = [ "rustfmt" ];
          python = [ "ruff_format" ];
          haskell = [
            "fourmolu"
            "stylish-haskell"
          ];
          tex = [ "latexindent" ];
          typst = [ "typstyle" ];
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
                local prefer_lsp = { 'vue' }
                local filetype = vim.bo.filetype

                local function contains(tbl, val)
                  for _, v in ipairs(tbl) do
                    if v == val then
                      return true
                    end
                  end
                  return false
                end

                local lsp_format
                if contains(prefer_lsp, filetype) then
                  lsp_format = "prefer"
                else
                  lsp_format = "never"
                end
                require('conform').format { async = false, lsp_format = lsp_format }
                vim.cmd.w()
            end
          '';
        options = {
          desc = "[F]ormat buffer";
        };
      }
    ];
  };
}
