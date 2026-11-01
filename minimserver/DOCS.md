# MinimServer

This app runs MinimServer 2 in a Home Assistant base image. Its Dockerfile
uses a multi-stage build, following the pattern used by the other apps in
this repository:

1. Use the architecture-specific upstream `minimworld/minimserver` image as
   a build stage.
2. Replace its bundled Java runtime with Eclipse Temurin 25, verifying the
   downloaded archive with its SHA-256 checksum.
3. Copy the MinimServer application and Temurin runtime into the final
   Home Assistant base image.

The Java replacement follows
[yasu-hide/minimserver-docker](https://github.com/yasu-hide/minimserver-docker).

## Storage

The app maps these persistent directories:

- `/MinimServer`: app configuration directory, mounted read-only as required
  by the upstream container instructions.
- `/opt/minimserver/data`: writable persistent MinimServer data, including
  configuration and library index data.
- `/media`: Home Assistant media directory, mounted read-only.

For a music library stored at `/media/Music/`, set the MinimServer
`contentDir` property to `/media/Music` in the MinimServer configuration
page. The upstream image automatically detects the library only when it is
mounted at `/Music`; this app intentionally preserves the requested
`/media/Music` path.

The music library is read-only to prevent MinimServer from modifying the
source files.

## Network

Host networking is enabled because MinimServer uses UPnP discovery and
multicast traffic. Port mappings are not required with host networking.

After the app starts, open the MinimServer configuration page at:

```text
http://<Home-Assistant-IP>:9790
```

The default HTTP configuration port is 9790. Confirm the content directory
and library scan status on the Status page.

## Architecture and runtime

The app supports Home Assistant OS on `aarch64` (including Raspberry Pi 4
running 64-bit HAOS) and `amd64`.

The upstream image is selected per architecture. The final image is based on
the Home Assistant base image used by the other apps in this repository.
The Dockerfile installs `gcompat` and `libstdc++` for the glibc-based
Temurin runtime on Alpine.

The Dockerfile and startup script have not yet been built or run on HAOS.
In particular, the Java runtime's compatibility with the selected Home
Assistant base image must be verified by building and starting the app on
both target architectures.

## Licensing

MinimServer is proprietary software and is subject to its own license terms.
The user must accept the license and activate any required trial or full
license through the MinimServer configuration page. License activation is
device-based; moving an installation to a different host may require
deactivation on the old host and activation on the new host.

The Dockerfile uses the upstream MinimServer image as a build stage and
copies the application into the locally built Home Assistant app image.
This repository does not publish a prebuilt MinimServer image. Users should
review and comply with the upstream license terms before building or using
the app.

See the [MinimServer container instructions](https://minimserver.com/running-container.html),
the [Linux quick start and licensing information](https://minimserver.com/quickstart-linux.html),
and the [MinimServer license terms](https://minimserver.com/license-terms.html).
