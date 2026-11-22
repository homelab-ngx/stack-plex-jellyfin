# stack-plex-jellyfin

[Plex](https://www.plex.tv) and [Jellyfin](https://jellyfin.org), two media
servers for the same libraries, as a stack for [homelab-ngx](https://github.com/homelab-ngx/homelab-ngx).
[WatchState](https://github.com/arabcoders/watchstate) keeps what you
watched the same in both.

Plex and Jellyfin are built from nixpkgs. WatchState runs from its image
under podman inside the stack. The stack installs under the name `players`.

## Getting started

1. Add the stack: `homelab stacks add github:homelab-ngx/stack-plex-jellyfin`,
   or Add stack on the dashboard's Stacks page.
2. On the stack's page, set `MEDIA_DIR` to the folder with your movies and
   shows. The servers read it through the folder's group.
3. Approve the grants and start the stack.
4. Open `https://plex.<your domain>` and `https://jellyfin.<your domain>`,
   sign in, and add libraries under `/pool/media`.
5. Open `https://watchstate.<your domain>` and add both servers by their
   routes.

For hardware transcoding, turn it on in each server's transcoder settings.
Set the transcode folders to `/run/plex-transcode` and
`/run/jellyfin-transcode`.

<!-- manifest:start -->
<!-- Made from homelab-stack.json. Change the manifest, not these lines. -->

## Grants

You approve each of these before the stack starts.

- Route: `plex.<your domain>` to port 32400 in the stack.
- Route: `jellyfin.<your domain>` to port 8096 in the stack.
- Route: `watchstate.<your domain>` to port 8088 in the stack.
- Storage: the folder in `MEDIA_DIR`, at `/pool/media` in the stack, read-write.
- GPU: the render devices of the host, `/dev/dri`.
- Port: 32400/tcp on the host to port 32400 in the stack, from the LAN of the host.
- Containers: Podman runs in the stack.

## Variables

| Name | Kind | Required | Default | Description |
| --- | --- | --- | --- | --- |
| `MEDIA_DIR` | path | yes |  | The media libraries Plex and Jellyfin show. Its group becomes the stack's media group, which both read as. |

## Backup

The stack recommends these folders. None is backed up until you add it to a backup.

- Plex settings: `/var/lib/plex` in the stack.
  - Without `/Plex Media Server/Metadata/**`. Posters and descriptions. Plex downloads them again.
  - Without `/Plex Media Server/Media/**`. Preview thumbnails and other files Plex makes from the library.
  - Without `/Plex Media Server/Cache/**`. Plex's cache. It fills again.
  - Without `/Plex Media Server/Plug-in Support/Caches/**`. Plex's cache. It fills again.
  - Without `/Plex Media Server/Codecs/**`. Codecs Plex downloads when it needs them.
  - Without `/Plex Media Server/Drivers/**`. Graphics drivers Plex downloads when it needs them.
  - Without `/Plex Media Server/Updates/**`. Downloaded updates.
  - Without `/Plex Media Server/Logs/**`. Log files.
  - Without `/Plex Media Server/Crash Reports/**`. Crash reports.
  - Without `/Plex Media Server/Diagnostics/**`. Diagnostic files.
- Jellyfin settings: `/var/lib/jellyfin` in the stack.
  - Without `/metadata/**`. Posters and descriptions. Jellyfin downloads them again.
  - Without `/data/metadata/**`. Posters and descriptions. Jellyfin downloads them again.
  - Without `/data/subtitles/**`. Downloaded subtitles. Jellyfin fetches them again.
  - Without `/cache/**`. Jellyfin's cache. It fills again.
  - Without `/log/**`. Log files.
- WatchState settings: `/var/lib/watchstate` in the stack.
  - Without `/cache/**`. WatchState's cache. It fills again.
  - Without `/logs/**`. Log files.
  - Without `/profiler/**`. Diagnostic files.

## Health

An update is kept when all of this holds, and rolled back when it does not.

- `plex.service` is active.
- `jellyfin.service` is active.
- `podman-watchstate.service` is active.

Manifest version 9, built with nixpkgs `nixos-unstable`. Runs on [homelab-ngx](https://github.com/homelab-ngx/homelab-ngx).

<!-- manifest:end -->

## License

MIT, see [LICENSE](LICENSE). Plex Media Server is not free software. nixpkgs
builds it as an unfree package, which this stack allows.
`icons/watchstate.png` is WatchState's logo, from
[arabcoders/watchstate](https://github.com/arabcoders/watchstate) (MIT).
