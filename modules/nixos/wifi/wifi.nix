{
  pkgs,
  config,
  lib,
  ...
}: let
  setNetwork = pkgs.writeShellScriptBin "setNetwork" ''
    PASSWORD=$(cat ${config.sops.secrets.shaan_key.path})
    ${pkgs.networkmanager}/bin/nmcli connection modify Shaan wifi-sec.psk "$PASSWORD"
  '';
in {
  options.wifi = {
    enable = lib.mkEnableOption "Enable wifi";
  };
  config = lib.mkIf config.wifi.enable {
    sops.secrets.shaan_key = {};

    networking.networkmanager = {
      ensureProfiles.profiles = {
        home-wifi = {
          connection = {
            id = "Shaan";
            type = "wifi";
          };
          wifi = {
            ssid = "Shaan";
            mode = "infrastructure";
          };
          wifi-security = {
            auth-alg = "open";
            key-mgmt = "wpa-psk";
          };
        };
      };
    };

    systemd.services.network-set = {
      after = ["NetworkManager.service"];
      wants = ["NetworkManager.service"];
      wantedBy = ["NetworkManager.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${setNetwork}/bin/setNetwork";
      };
    };
  };
}
