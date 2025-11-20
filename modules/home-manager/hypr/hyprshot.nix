{
    programs.hyprshot = builtins.trace "modularize hyprshot" {
        enable = true;
        saveLocation = "$HOME/Pictures/Screenshots";
    };
}
