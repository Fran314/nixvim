{
  pkgs,
  lib,
  inputs,
  ...
}:

with lib;
{
  options = {

  };

  config = {
    colorschemes = {
      catppuccin = {
        enable = true;
        settings = {
          flavour = "mocha";
          transparent_background = true;
          float = {
            transparent = true;
            solid = false;
          };
        };
      };

      tokyonight = {
        # enable = true;
        settings = {
          style = "night";
          transparent = true;
        };
      };
    };

    highlightOverride = {
      LineNr.fg = "#9399b2";
      CursorLineNr = {
        bold = true;
        italic = true;
        fg = "#ff9e64";

        bg = "NONE";
      };
      CursorLine = {
        bg = "NONE";
      };
    };

    plugins = {
      web-devicons.enable = true;

      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin-nvim";
            component_separators = "|";
            # section_separators = "";
          };
          sections = {
            lualine_c.__raw = "{ { 'filename', file_status = true, path = 1 } }";
          };
        };
      };
    };
  };
}
