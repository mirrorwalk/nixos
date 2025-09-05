{
    programs.ghostty = {
        enable = true;
        settings = {
            theme = "CyberpunkScarletProtocol";
            confirm-close-surface = false;
            font-family = "Orbitron Regular";
            font-size = 12;
            shell-integration-features = "cursor,sudo,no-title";
        };
        enableZshIntegration = true;
        installBatSyntax = true;
        installVimSyntax = true;
    };

}
