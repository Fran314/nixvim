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
        "*.typ"
      ];
      group = "autowrap";
      command = "setlocal wrap";
    }
  ];
}
