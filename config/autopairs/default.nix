{
  # Inserts matching pairs of parens, brackets, etc.
  # https://nix-community.github.io/nixvim/plugins/nvim-autopairs/index.html
  # Auto-inserting `(` after accepting a function completion is handled
  # natively by blink.cmp (completion.accept.auto_brackets, on by default).
  plugins.nvim-autopairs = {
    enable = true;
  };
}
