# MinimServer

This app runs MinimServer 2 using the official `minimworld/minimserver`
container as its base and replaces its bundled Java runtime with Eclipse
Temurin 25. The Java replacement follows the build in
[yasu-hide/minimserver-docker](https://github.com/yasu-hide/minimserver-docker).

## Storage

The Home Assistant `/media` directory is mounted read-only at `/media`
inside the container. For a music library stored at:

```text
/media/Music/
```

set the MinimServer `contentDir` property to:

```text
/media/Music
```

The MinimServer configuration and index data are persisted in the app's
private data directory, mounted at `/opt/minimserver/data`.

The music library is read-only to prevent MinimServer from modifying the
source files.

## Network

Host networking is enabled because MinimServer uses UPnP discovery and
multicast traffic. Port mappings are not required with host networking.

After the app starts, open the MinimServer configuration page at:

```text
http://<Home-Assistant-IP>:9790
```

Use the Status page to confirm the content directory and library scan status.
The default HTTP configuration port is 9790. MinimServer's preferred UPnP
service port is 9791.

## Architecture

The app supports Home Assistant OS on `aarch64` (including Raspberry Pi 4
running 64-bit HAOS) and `amd64`.

The Dockerfile selects the corresponding upstream image and installs the
matching Temurin 25 archive. The downloaded JDK archive is verified against
its SHA-256 checksum before installation.

## Licensing

MinimServer is proprietary software. By installing and using it, you agree
to the MinimServer license terms. This app does not include a separately
redistributed MinimServer binary; its Docker build uses the upstream
`minimworld/minimserver` image as its base.

See the [MinimServer container instructions](https://minimserver.com/running-container.html)
and the [MinimServer license terms](https://minimserver.com/licensing.html).
