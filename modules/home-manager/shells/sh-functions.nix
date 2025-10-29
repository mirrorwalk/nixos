{lib, ...}: {
  options.shells.shFunctions = lib.mkOption {
    type = lib.types.str;
    default = ''
      fcd() {
          local dir
          dir=$(fd --type d 2>/dev/null | fzf)
          cd "$dir"
      }

      listpaths() {
          echo $PATH | tr ':' '\n'
      }

      nvimcd() {
          if [ -d "$1" ]; then
              cd "$1" || return
              nvim .
          else
              nvim "$@"
          fi
      }
    '';
  };
}
