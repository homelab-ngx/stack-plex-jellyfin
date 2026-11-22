{ config, lib, ... }:

# Plex and Jellyfin, which show the same libraries, and WatchState, which
# keeps what you watched in step between them. Plex clients on the LAN also
# connect straight to port 32400 on the homelab host, which forwards it here
# (the manifest's port grant). The homelab daemon's host module gives the
# media group the libraries' gid, gives the stack the host's GPU drivers and
# opens the ports.
{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [ "plexmediaserver" ];

  users.groups.media = { };

  services.plex.enable = true;
  users.users.plex.extraGroups = [ "media" ];

  services.jellyfin.enable = true;
  users.users.jellyfin.extraGroups = [ "media" ];

  # Fast transcode folders, for Plex's and Jellyfin's transcoder settings.
  systemd.tmpfiles.rules = [
    "d /run/plex-transcode     0755 plex     media -"
    "d /run/jellyfin-transcode 0755 jellyfin media -"
    "d /var/lib/watchstate     0755 1000     1000  -"
  ];

  # WatchState reaches Plex and Jellyfin through their routes, like any
  # client; set them up in its web UI.
  virtualisation.podman.enable = true;
  virtualisation.oci-containers.backend = "podman";
  virtualisation.oci-containers.containers.watchstate = {
    # v1.10.12-amd64
    image = "ghcr.io/arabcoders/watchstate@sha256:4f3ff8be24177121a8b2809c9f5e5aaac09e8d415b1812e98feffe8b48c93c93";
    ports = [ "8088:8080" ];
    volumes = [ "/var/lib/watchstate:/config" ];
    environment = {
      TZ = config.time.timeZone or "UTC";
      WS_GUID_PATH_ENABLED = "1";
      WS_CRON_IMPORT = "1";
      WS_CRON_EXPORT = "1";
    };
    # The image's own user.
    extraOptions = [ "--user=1000:1000" ];
  };
}
