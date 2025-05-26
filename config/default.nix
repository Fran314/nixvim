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
  imports = [
    ./appearance
    ./barbar
    ./autowrap
    ./mini
    ./autopairs

    # ./neo-tree

    ./gitsigns
    ./telescope
    ./lsp
    ./conform
    ./nvim-cmp
    ./treesitter
  ];

  # enable = true;
  # defaultEditor = true;

  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#globals
  globals = {
    # Set <space> as the leader key
    # See `:help mapleader`
    mapleader = " ";
    maplocalleader = " ";
  };

  # #  See `:help 'clipboard'`
  # clipboard = {
  # 	providers = {
  # 		wl-copy.enable = true; # For Wayland
  # 		xsel.enable = true; # For X11
  # 	};
  # };

  # [[ Setting options ]]
  # See `:help vim.opt`
  # NOTE: You can change these options as you wish!
  #  For more options, you can see `:help option-list`
  # https://nix-community.github.io/nixvim/NeovimOptions/index.html?highlight=globals#opts
  opts = {
    # Show line numbers
    number = true;
    # You can also add relative line numbers, to help with jumping.
    #  Experiment for yourself to see if you like it!
    relativenumber = true;

    # Enable mouse mode, can be useful for resizing splits for example!
    mouse = "a";

    # Don't show the mode, since it's already in the statusline
    showmode = false;

    # Enable break indent
    breakindent = true;

    # Persistent undo
    undofile = true;
    undodir.__raw = "vim.fn.expand(\"~\") .. \"/.nvim/undo\"";

    # Case-insensitive searching UNLESS \C or one or more capital letters in the search term
    ignorecase = true;
    smartcase = true;

    # Keep signcolumn on by default
    signcolumn = "yes";

    # # Decrease update time
    # updatetime = 250;
    #
    # # Decrease mapped sequence wait time
    # # Displays which-key popup sooner
    # timeoutlen = 300;

    # Configure how new splits should be opened
    splitright = true;
    splitbelow = true;

    # Sets how neovim will display certain whitespace characters in the editor
    #  See `:help 'list'`
    #  and `:help 'listchars'`
    list = true;
    # NOTE: .__raw here means that this field is raw lua code
    listchars.__raw = "{ tab = '» ', trail = '·', nbsp = '␣' }";

    # Preview substitutions live, as you type!
    inccommand = "split";

    # Show which line your cursor is on
    cursorline = true;

    # if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
    # instead raise a dialog asking if you wish to save the current file(s)
    # See `:help 'confirm'`
    confirm = true;

    tabstop = 4;
    softtabstop = 4;
    shiftwidth = 4;
    expandtab = false;

    autoindent = true;
    smartindent = true;

    wrap = false;

    hlsearch = false;
    incsearch = true;

    termguicolors = true;

    scrolloff = 8;

    fillchars = "eob: ";
  };

  diagnostic.settings = {
    virtual_lines = {
      current_line = true;
    };
    virtual_text = false;
    float = {
      border = [
        "╭"
        "─"
        "╮"
        "│"
        "╯"
        "─"
        "╰"
        "│"
      ];
    };
  };

  plugins = {
    auto-session.enable = true;

    comment.enable = true;

    # Detect tabstop and shiftwidth automatically
    # https://nix-community.github.io/nixvim/plugins/sleuth/index.html
    sleuth.enable = true;
  };

  keymaps = lib.mkMerge [
    # Move and auto-indent selected lines
    (keymap "v" "J" ":m '>+1<CR>gv=gv")
    (keymap "v" "K" ":m '<-2<CR>gv=gv")

    # Better search
    (keymap "n" "n" "nzzzv")
    (keymap "n" "N" "Nzzzv")

    (keymap "n" "<leader>e" { __raw = "vim.diagnostic.open_float"; })

    # Paste without losing copied text
    (keymap "x" "<leader>p" "\"_dP")

    # Make current buffer executable
    (keymap "n" "<C-x>" "<cmd>!chmod +x %<CR><CR>")

    # Set un/wrap
    (keymap "n" "<leader>ww" "<cmd>set wrap<CR>")
    (keymap "n" "<leader>wn" "<cmd>set nowrap<CR>")
  ];

  extraConfigLuaPost = ''
    -- RESTORE CURSOR POSITION ---
    vim.api.nvim_create_autocmd("BufRead", {
      callback = function(opts)
        vim.api.nvim_create_autocmd("BufWinEnter", {
          once = true,
          buffer = opts.buf,
          callback = function()
            local ft = vim.bo[opts.buf].filetype
            local last_known_line = vim.api.nvim_buf_get_mark(opts.buf, '"')[1]
            if
              not (ft:match("commit") and ft:match("rebase"))
              and last_known_line > 1
              and last_known_line <= vim.api.nvim_buf_line_count(opts.buf)
            then
              vim.api.nvim_feedkeys([[g`"]], "nx", false)
            end
          end,
        })
      end,
    })
    ------------------------------
  '';
}
