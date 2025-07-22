# NixVim Configuration

My personal NixVim Configuration

This repo takes heavy inspiration from the following sources:

- [JMartJonesy/kickstart.nixvim](https://github.com/JMartJonesy/kickstart.nixvim),
  for most of the plugin configuration and project structure
- [NixVim's standalone flake template](https://github.com/nix-community/nixvim/blob/main/templates/simple/flake.nix),
  originally documented in
  [here](https://nix-community.github.io/nixvim/user-guide/install.html), from
  which I took the `flake.nix` file which is still sorcery to me and I have no
  idea why it works, but I'm glad that it works

## Usage

Add this repo to the inputs as follows

```nix
inputs = {
    # ...
    nixvim.url = "github:Fran314/nixvim";
};
```

and then import the default package in the system configuration, with

```nix
{
  environment.systemPackages = [ inputs.nixvim.packages.${system}.default ];
  # Alternatively, for minimal install
  # environment.systemPackages = [ inputs.nixvim.packages.${system}.nvim-minimal ];

  # This is not necessary, but suggested
  environment.variables.EDITOR = "nvim";
}
```
