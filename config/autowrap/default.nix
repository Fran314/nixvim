{ pkgs, inputs, ... }:

{
  autoGroups = {
    autowrap = {
      clear = true;
    };
  };

  autoCmd = [
    {
      event = "BufEnter";
      pattern = [
        "*.md"
        "*.tex"
      ];
      group = "autowrap";
      command = "setlocal wrap";
    }
  ];
}
