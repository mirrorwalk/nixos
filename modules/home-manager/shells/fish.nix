{
  programs.fish = {
    enable = true;
    shellAliases = {
      enix = "cd $HOME/.config/nixos && nvim $HOME/.config/nixos";
      la = "ls -aF --color=auto";
      tmuxs = "tmux new -s";
      tmuxa = "tmux attach -t";
      nix-shell = "nom-shell";
      nix-build = "nom-build";
    };
    functions = {
      gitignore = "curl -sL https://www.gitignore.io/api/$argv";
      fcd = ''
        set dir $(fd --type d 2>/dev/null | fzf)
        cd "$dir"
      '';
      nvim-config = ''
        cd ~/.config/nvim
        nvim .
    '';
    fish_greeting = "";
    };
  };
}
