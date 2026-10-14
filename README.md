# Debian + S6

![GitHub release (latest by date)](https://img.shields.io/github/v/release/bfren/docker-debian-s6) ![Docker Pulls](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fpulls%2Fdebian-s6?) ![Docker Image Size](https://img.shields.io/endpoint?url=https%3A%2F%2Fbfren.dev%2Fdocker%2Fsize%2Fdebian-s6) ![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/bfren/docker-debian-s6/dev.yml?branch=main)

[Docker Hub](https://hub.docker.com/r/bfren/debian-s6) - [Quay.io](https://quay.io/repository/bfren/debian-s6) - [bfren ecosystem](https://github.com/bfren/docker)

## Introduction

This is the [bfren ecosystem](https://github.com/bfren/docker) base image for long-running services that need [Debian](https://www.debian.org) - glibc, or packages that are not available (or not reliable) on Alpine. It is built on [Debian](https://github.com/bfren/docker-debian).

It is the same platform as [Alpine + S6](https://github.com/bfren/docker-alpine-s6) - that image's overlay is copied in when this image is built - so initialisation, services, permissions, templates, scheduled tasks and health checks all work identically. This page covers how to use it, and what is different on Debian.

It is [Debian](https://github.com/bfren/docker-debian) with:

* the [S6 Overlay](https://github.com/just-containers/s6-overlay) process supervisor, so one container can run a service *and* the jobs around it (cron, log forwarding, start-up checks)
* [Nushell](https://www.nushell.sh) with the `bf` and `bf-s6` modules, for writing start-up scripts and helpers
* a standard layout for initialisation, permissions, templates and scheduled tasks

You probably don't want to run this image on its own. Use it as the `FROM` line for your own image. For images that run a single command or tool, use [Debian](https://github.com/bfren/docker-debian) instead. If you don't need Debian, prefer [Alpine + S6](https://github.com/bfren/docker-alpine-s6) - it is smaller.

## Quickstart

A minimal image that runs one supervised service:

```plain
my-image/
├── Dockerfile
└── overlay/
    └── etc/s6-overlay/
        ├── s6-rc.d/myapp/
        │   ├── dependencies.d/init     (empty file)
        │   ├── type                    (contains: longrun)
        │   ├── run
        │   └── finish
        └── user-bundles.d/user/contents.d/myapp   (empty file)
```

`Dockerfile`:

```dockerfile
FROM quay.io/bfren/debian-s6:debian13

ARG BF_IMAGE=my-image
ARG BF_VERSION=1.0.0

COPY ./overlay /
RUN apt-get update && apt-get install --no-install-recommends -y myapp && bf-install
```

`run` - start your service in the foreground, **ending with `bf-s6 svc launch`**:

```nu
#!/usr/bin/nu

use bf
use bf-s6
bf env load

# Start myapp in the foreground so it can be supervised by S6
def main [
    name: string    # The service name, passed by s6-supervise
] {
    # set executable name - used to make log output more useful
    bf env x_set --override run $name

    # run checks before executing service
    bf write debug "No pre-run checks required."

    # flags:
    #   --foreground  stay in the foreground (allows S6 to supervise the service)
    bf write "Starting myapp."
    let args = [
        "--foreground"
    ]
    bf-s6 svc launch myapp ...$args
}
```

`finish` - pass S6's arguments through so the container only stops if `myapp` fails:

```nu
#!/usr/bin/nu

use bf
use bf-s6
bf env load -x myapp

# Show helpful log message
def main [...args] { bf-s6 svc finish --terminate ...$args }
```

Build it, run it, and check `myapp` is supervised directly by S6:

```sh
docker build -t my-image . && docker run -d --name test my-image
docker exec test ps -o pid,ppid,args
```

`myapp`'s parent should be `s6-supervise myapp`. If `nu` or a shell is in between, the `run` script is not ending with `bf-s6 svc launch`.

## Features

* 🌀 Debian 12 and 13 - choose with the image tag
* 🧭 S6 Overlay process supervision, with clean shutdown on `docker stop`
* 🚀 Nushell start-up scripts in `/etc/bf/init.d`, run in order before any service starts
* 🔐 Permissions applied from simple text files in `/etc/bf/ch.d`
* 📝 Configuration files generated from [esh](https://github.com/jirutka/esh) templates in `/etc/bf/templates`
* ⏰ Cron, with folders for jobs every minute, 15 minutes, hour, day, week and month
* 🕐 Timezone set from `BF_TZ` during start-up
* 🛑 The container stops if a service fails - but not when you restart a service on purpose, or on `docker stop`
* 🩺 A `HEALTHCHECK` that checks cron is running, which you can override with your own script
* 📦 `bf pkg` works with `apt`, so your install scripts read the same as on Alpine
* 🧪 Built-in test runner that checks its tests really execute
* 🖥️ Built for `linux/amd64`, `linux/arm64` and `linux/arm/v7`

## Tags

Images are published to Docker Hub (`bfren/debian-s6`) and Quay.io (`quay.io/bfren/debian-s6`).

| Tag                           | Example                | Use when                                              |
| ----------------------------- | ---------------------- | ----------------------------------------------------- |
| `debianX`                     | `debian13`             | You want the latest image for a Debian version        |
| `debianX-MAJOR`               | `debian13-4`           | You want updates, but not breaking changes            |
| `debianX-MINOR`               | `debian13-4.4`         | You want fixes only - **recommended for building on** |
| `debianX-VERSION`             | `debian13-4.4.0`       | You want to pin this image exactly                    |
| `debianX.Y`                   | `debian13.7`           | You want an exact Debian point release                |
| `debianX.Y-VERSION`           | `debian13.7-4.4.0`     | You want to pin both                                  |
| `NAME`, `NAME-MAJOR` …        | `trixie`, `trixie-4.4` | As above, using the Debian release name               |
| `latest`, `4`, `4.4`, `4.4.0` |                        | As above, on the newest Debian version                |

| Debian        | Security support ends | Community LTS ends |
| ------------- | --------------------- | ------------------ |
| 13 (trixie)   | 2028-08-09            | 2030-06-30         |
| 12 (bookworm) | ended 2026-07-11      | 2028-06-30         |

Debian 12 has moved to Debian's volunteer-run LTS. Use Debian 13 for anything new. [Source: endoflife.date](https://endoflife.date/debian)

## Configuration

### Environment Variables

| Variable            | Values     | Description                                                 | Default         |
| ------------------- | ---------- | ----------------------------------------------------------- | --------------- |
| `BF_DEBUG`          | `0`, `1`   | Show detailed output from `bf` scripts.                     | `0`             |
| `BF_TZ`             | timezone   | Container timezone, e.g. `Europe/London`.                   | `Europe/London` |
| `BF_CRON_LOG_LEVEL` | `0` to `8` | Cron log detail - `0` is the most verbose.                  | `8`             |
| `BF_ENABLE_INIT_CH` | `0`, `1`   | Set to `0` to skip applying `ch.d` permissions at start-up. | `1`             |

### Build Arguments

| Argument        | Description                                                                   |
| --------------- | ----------------------------------------------------------------------------- |
| `BF_IMAGE`      | **Required by `bf-install`.** The image name, saved to `/etc/bf/IMAGE`.       |
| `BF_VERSION`    | **Required by `bf-install`.** The image version, saved to `/etc/bf/VERSION`.  |
| `BF_PUBLISHING` | Set to `1` for release builds - removes the test files and preinstall script. |

## How It Works

Starting, initialisation scripts, service scripts, permissions, templates, scheduled tasks and the `bf-s6` module all work exactly as they do in [Alpine + S6](https://github.com/bfren/docker-alpine-s6#how-it-works) - read that for the full guide. In short:

* **Starting** - S6 is the entrypoint. The `init` service saves the container's environment to `/etc/bf/env.d` and runs every `*.nu` file in `/etc/bf/init.d` in order (yours should start at `10` or above), then S6 starts each service in `user-bundles.d/user/contents.d`.
* **Services** - the `run` script ends with `bf-s6 svc launch`, so S6 supervises your service directly. The `finish` script calls `bf-s6 svc finish --terminate`, which stops the container if the service fails.
* **Permissions** - lines in `/etc/bf/ch.d` files are `path owner [file-mode] [directory-mode]`.
* **Templates** - `/etc/bf/templates/myapp.conf.esh` is generated with `bf-s6 esh template "/etc/myapp/myapp.conf"`.
* **Scheduled tasks** - executable scripts in `/etc/periodic/1min`, `15min`, `hourly`, `daily` (02:00), `weekly` (03:00 on Saturdays) and `monthly` (05:00 on the 1st).

### What is different from Alpine + S6

| Area                 | Alpine + S6                                      | Debian + S6                                                                                                             |
| -------------------- | ------------------------------------------------ | ----------------------------------------------------------------------------------------------------------------------- |
| Base image           | [Alpine](https://github.com/bfren/docker-alpine) | [Debian](https://github.com/bfren/docker-debian)                                                                        |
| Package manager      | `apk`                                            | `apt-get` - `bf pkg install`, `remove` and `upgrade` run `apt-get update` first, then the action, non-interactively     |
| Recommended packages | n/a                                              | Not installed (`Install-Recommends` and `Install-Suggests` are `0`)                                                     |
| C library            | musl                                             | glibc                                                                                                                   |
| Utilities            | Alpine's own Busybox                             | Busybox replaces the Debian equivalents (except `dpkg`, `grep`, `find` and a few others that Debian's packages rely on) |
| Cron                 | Busybox `crond`                                  | Busybox `crond`                                                                                                         |
| `bf clean`           | Removes the `apk` cache                          | Removes `/var/lib/apt/lists` and `/usr/share/man`                                                                       |
| `bf tz`              | Installs `tzdata`, then removes it               | Uses the `tzdata` already in Debian                                                                                     |

Everything else - the `bf` and `bf-s6` modules, `bf-install`, `/etc/bf` layout, service scripts, crontab and health check - is the same code, so scripts you write for one image work on the other apart from package names.

### Health checks

The image runs `healthcheck` every 30 seconds (every 2 seconds during the first 60 seconds, so a new container reports healthy quickly). It is a link to `/usr/bin/bf/bf-healthcheck`, which checks that the cron service is running. Images that run a service should check it instead: replace `/usr/bin/bf/bf-healthcheck` in your image with a script that exits non-zero when the service is unhealthy. Your script replaces the cron check, so add one if you still need it (`s6-svstat -u /run/service/cron` prints `true` when cron is up).

## Testing

`/test` runs the Nushell tests in `/etc/nu/scripts/tests` (add yours to `tests/mod.nu`). Before running, it checks that tests really execute and fails if they don't. Tests are removed from published images, so run them on your own builds.

```sh
./test.sh        # builds the Debian 13 image and runs /test
./test.sh 12     # the same for Debian 12
```

## Troubleshooting

### Package not found

`bf pkg install` runs `apt-get update` each time, so a "not found" error usually means the package name is Debian's and not Alpine's (e.g. `libpq-dev`, not `postgresql-dev`; `build-essential`, not `build-base`).

### A service's parent process is `nu` or a shell, not `s6-supervise`

The `run` script is not ending with `bf-s6 svc launch`, or a wrapper it calls is missing `exec`. Signals from S6 then reach the wrapper instead of your service.

### The `run` script fails with "extra positional argument"

S6 passes the service name to `run`, so `main` must accept it - use `def main [name: string]`, not `def main []`.

### The container stops when I restart a service

Check the service's `finish` script passes `...$args` to `bf-s6 svc finish`. Without them, the finish script can't tell a deliberate restart from a crash, so it stops the container to be safe.

### The container stops during start-up

An initialisation script failed. Run with `BF_DEBUG=1` and check `docker logs` - the failing script is named in the output.

### `/test` says the tests directory does not exist

Published images have their tests removed. Build the image yourself without `BF_PUBLISHING=1`.

## FAQs

### Should I use Debian + S6 or Alpine + S6?

Alpine + S6, unless something you need requires glibc or a Debian package - it is smaller. Choose Debian for software that needs glibc, or that is only packaged or supported for Debian ([`bfren/mariadb`](https://github.com/bfren/docker-mariadb) offers both Alpine and Debian variants).

### Should I use this image or Debian?

Use this one for long-running services, especially if they need scheduled tasks or start-up checks. Use [Debian](https://github.com/bfren/docker-debian) for images that run a single command - a CLI tool, a build step.

### Why does this repository contain so little?

The platform is shared. When this image is built, the [Alpine + S6 overlay](https://github.com/bfren/docker-alpine-s6) is cloned at the version set in `generate-dockerfiles.sh` and copied on top of the [Debian](https://github.com/bfren/docker-debian) base image, and the S6 Overlay is added. The Debian-specific parts (`bf pkg`, `bf clean`, `bf tz`) come from the Debian base image.

## Licence

> [MIT](https://mit.bfren.dev/2022)

## Copyright

> Copyright (c) 2022-2026 [bfren](https://bfren.dev) (unless otherwise stated)
