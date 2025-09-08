{
    programs.ssh = {
        enable = true;
        enableDefaultConfig = false;
        matchBlocks."*" = {
            addKeysToAgent = "yes";
            serverAliveInterval = 60;
            serverAliveCountMax = 5;
            forwardAgent = false;
            compression = true;
        };
    };
}
