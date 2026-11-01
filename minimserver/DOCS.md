# MinimServer

This app builds MinimServer 2.2 into a Home Assistant base image. The
Dockerfile uses architecture-specific official Linux archives and verifies
each archive with SHA-256 before extracting it.

The build has three stages:

1. Download and extract the official MinimServer 2.2 Linux archive for
   `amd64` or `arm64`.
2. Select the matching Java 25 JRE from the official multi-architecture
   `eclipse-temurin:25-jre-alpine` image.
3. Copy MinimServer and the JRE into the final Home Assistant base image.

The MinimServer archive URLs and SHA-256 values are pinned in the Dockerfile.
To update MinimServer, update the versioned archive URL and its verified
checksum for both architectures.

## Storage

The app maps these persistent directories:

- `/MinimServer`: app configuration directory, mounted read-only as
  required by the upstream container instructions.
- `/opt/minimserver/data`: writable persistent MinimServer data,
  including configuration and library index data.
- `/media`: Home Assistant media directory, mounted read-only.

For a music library stored at `/media/Music/`, set the MinimServer
`contentDir` property to `/media/Music` in the MinimServer
configuration page. The upstream Docker image auto-detects a library mounted
at `/Music`; this app intentionally preserves the Home Assistant
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

The app supports Home Assistant OS on `aarch64` (including Raspberry
Pi 4 running 64-bit HAOS) and `amd64`.

The Dockerfile selects the MinimServer archive and Temurin JRE for the
requested architecture. It also installs Alpine compatibility libraries in
the final image. Compatibility of the MinimServer binaries with this
Alpine-based runtime still needs to be confirmed by building and starting
the app on the target hardware.

The startup command uses MinimServer's `startd wait` mode, matching
the command used by the upstream MinimServer container. The upstream Linux
instructions also document `/opt/minimserver/bin/startd` as the
daemon startup command.

The Dockerfile and startup script have not yet been built or run on HAOS.
In particular, runtime compatibility, UPnP discovery, and persistence
behavior remain unverified.

## Licensing

MinimServer is proprietary software and is subject to its own license terms.
The official Linux installation instructions state that the user must accept
the license before downloading the archive. Users must review and comply
with the applicable terms and activate any required trial or full license
through the MinimServer configuration page.

License activation is device-based; moving an installation to a different
host may require deactivation on the old host and activation on the new host.

This repository does not publish a prebuilt MinimServer image. The Dockerfile
downloads the official Linux archives during a local Home Assistant app
build. Whether this packaging method is permitted for every intended
redistribution or deployment scenario depends on the MinimServer license
terms; seek confirmation from the rights holder if that point is material.

See the [MinimServer container instructions](https://minimserver.com/running-container.html),
the [Linux quick start and licensing information](https://minimserver.com/quickstart-linux.html),
the [Linux installation instructions](https://minimserver.com/install-linux-mserver.html),
and the [MinimServer license terms](https://minimserver.com/license-terms.html).
