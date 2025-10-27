{
  pkgs,
  lib,
  config,
  ...
}: let
  enix = pkgs.writeShellScriptBin "enix" ''
    enix() {
        if [ -n "$TMUX" ] && [ "$(tmux display-message -p '#S')" = "nixos" ]; then
            nvim ~/.config/nixos
        elif ! command -v tmux >/dev/null; then
            cd $HOME/.config/nixos
            git pull && nvim .
        elif tmux has-session -t nixos 2>/dev/null; then
            if [ -n "$TMUX" ]; then
                tmux switch-client -t "nixos"
            else
                tmux attach-session -t "nixos"
            fi
        else
            cd ~/.config/nixos
            if git pull; then
                tmux new -d -s nixos -c ~/.config/nixos 'nvim .'
                if [ -n "$TMUX" ]; then
                    tmux switch-client -t "nixos"
                else
                    tmux attach-session -t "nixos"
                fi
            fi
        fi
    }
  '';
in {
  home.packages = lib.mkIf config.shells.tmux.enable [
    enix
  ];
}
