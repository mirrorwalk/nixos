{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        shellAliases = {
            enix = "cd $HOME/.config/nixos && nvim $HOME/.config/nixos";
            la = "ls -aF --color=auto";
            tmuxs = "tmux new -s";
            tmuxa = "tmux attach -t";
            nix-shell = "nom-shell";
            nix-build = "nom-build";
        };
        initContent = ''
            if [ -f $HOME/.config/zsh/paths.zsh ]; then
                source $HOME/.config/zsh/paths.zsh
            fi

            # Functions
            fcd() {
                local dir
                dir=$(fd --type d 2>/dev/null | fzf)
                cd "$dir"
            }

            addpath() {
                if [ -d "$1" ]; then
                    # Convert to absolute path
                    local abs_path
                    abs_path=$(realpath "$1" 2>/dev/null || readlink -f "$1")
                    # Check if already in PATH
                    case ":$PATH:" in
                        *":$abs_path:"*)
                            echo "$abs_path is already in PATH"
                            return
                            ;;
                    esac
                    # Add to current session
                    export PATH="$abs_path:$PATH"
                    echo "Added $abs_path to PATH"
                    # Persist it in ~/.config/zsh/paths.zsh if not already there
                    local path_file="$HOME/.config/zsh/paths.zsh"
                    grep -qxF "export PATH=\"$abs_path:\$PATH\"" "$path_file" 2>/dev/null || \
                        echo "export PATH=\"$abs_path:\$PATH\"" >> "$path_file"
                else
                    echo "Directory $1 does not exist."
                fi
            }

            listpaths() {
                echo $PATH | tr ':' '\n'
            }

            rebuild-nixos-no-git() {
                local prev_dir="$PWD"
                cd "$HOME/.config/nixos" || {
                    echo "Could not find $HOME/.config/nixos"
                    return 1
                }
                sudo nixos-rebuild switch --flake "$HOME/.config/nixos#desktop"
                cd "$prev_dir" || return
            }

            rebuild-nixos() {
                local prev_dir="$PWD"
                cd "$HOME/.config/nixos" || {
                    echo "Could not find $HOME/.config/nixos"
                    return 1
                }
                if [[ -z $(git status --porcelain) ]]; then
                    echo "No configuration changes — skipping rebuild."
                    return 0
                fi
                echo "Building new NixOS configuration (test build)..."
                if nixos-rebuild build --flake "$HOME/.config/nixos#desktop"; then
                    echo "Build succeeded. Committing changes..."
                    rm ./result
                    git add .
                    git commit -m "Backup: $(date '+%Y-%m-%d %H:%M:%S')"
                    git push
                    echo "Activating committed configuration..."
                    sudo nixos-rebuild switch --flake "$HOME/.config/nixos#desktop"
                    echo "Rebuild complete."
                    cd "$prev_dir" || return
                else
                    echo "Build failed — no commit made."
                    return 1
                fi
                cd "$prev_dir" || return
            }

            nvimcd() {
                if [[ -d $1 ]]; then
                    cd "$1" || return
                    nvim .
                else
                    nvim "$@"
                fi
            }

            bindkey -s '^x' "tmux-workspace\n"

            # Other
            setopt PROMPT_SUBST
            PS1='%F{cyan}[%F{yellow}%n%F{green}@%F{blue}%m %F{magenta}%~%F{cyan}]%F{red}$(git branch --show-current 2>/dev/null | sed "s/.*/(&)/")%F{cyan}%(1j.(%j).)%f$ '
            eval "$(direnv hook zsh)"
            autoload -U compinit
            compinit
            source <(jj util completion zsh)

            if command -v tmux &> /dev/null && [ -z "$TMUX" ]; then
                tmux attach-session -t default || tmux new-session -s default
            fi
        '';
    };
}
