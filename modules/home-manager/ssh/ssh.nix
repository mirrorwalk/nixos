{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = {
      identityFile = "~/.ssh/id_ed25519";

      compression = true;

      serverAliveInterval = 60;
      serverAliveCountMax = 3;

      extraOptions = {
        AddKeysToAgent = "yes";

        HashKnownHosts = "yes";

        StrictHostKeyChecking = "accept-new";

        ControlMaster = "auto";
        ControlPath = "~/.ssh/master-%r@%n:%p";
        ControlPersist = "15m";

        Ciphers = "chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com";
        KexAlgorithms = "curve25519-sha256,curve25519-sha256@libssh.org";
        MACs = "hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com";
      };
    };
  };
}
