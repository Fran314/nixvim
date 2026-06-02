{
  plugins = {
    treesitter = {
      enable = true;

      # highlight and indent are native nvim-treesitter (main branch) options.
      # The old settings.{highlight,indent} path is the deprecated master branch.
      highlight = {
        enable = true;
        disable = [ "scss" ];
      };

      indent.enable = true;
    };
  };
}
