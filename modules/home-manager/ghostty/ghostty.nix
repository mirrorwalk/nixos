{
    programs.ghostty = {
        enable = true;
        settings = {
            theme = "Cyberpunk Scarlet Protocol";
            confirm-close-surface = false;
            font-family = "Orbitron Regular";
            font-size = 12;
            shell-integration-features = "cursor,sudo,no-title";
            command = "tmux-startup";
        };
        # enableZshIntegration = true;
        # enableFishIntegration = true;
        enableBashIntegration = true;
        installBatSyntax = true;
        installVimSyntax = true;
    };

}
