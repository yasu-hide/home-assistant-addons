# MinimServer

This app runs MinimServer 2 using the official `minimworld/minimserver`
container as its base and replaces the bundled Java runtime with Eclipse
Temurin 25. The Java replacement follows the build in
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

## Architecture

The app supports Home Assistant OS on `aarch64` (including Raspberry Pi 4
running 64-bit HAOS) and `amd64`.

The Dockerfile selects the corresponding upstream image and installs the
matching Temurin 25 archive. The downloaded JDK archive is verified against
its SHA-256 checksum before installation.

## Licensing

MinimServer is proprietary software and is subject to its own license terms.
The user must accept the license and activate any required trial or full
license through the MinimServer configuration page. License activation is
device-based; moving an installation to a different host may require
deactivation on the old host and activation on the new host.

This repository contains a Dockerfile that builds locally from the upstream
MinimServer image; it does not publish a prebuilt MinimServer image.

See the [MinimServer container instructions](https://minimserver.com/running-container.html),
the [Linux quick start and licensing information](https://minimserver.com/quickstart-linux.html),
and the [MinimServer license terms](https://minimserver.com/license-terms.html).
