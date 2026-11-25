# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.4] - 2026-11-25

### Changed

- The base image is pinned to its exact Debian point release (`debian13.8-6.0.3`, `debian12.15-6.0.3`) instead of the
  release name, so the point release in the tags always matches the image.

### Fixed

- The Debian 13 image is published as `debian13.8` and `debian13.8-5.0.4`. 5.0.3 was already on Debian 13.8, but
  was published as `debian13.7-5.0.3` and moved the `debian13.7` tag to it - use `debian13.7-5.0.2` for Debian 13.7.

## [5.0.3] - 2026-11-25

### Changed

- Base image updated to `bfren/debian` 6.0.3, which moves Debian 13 to 13.8 (so the `debian13` and `trixie` tags
  move to it, published as `debian13.8`) and rebuilds BusyBox, figlet and Nushell without changing their versions -
  see the [Debian changelog](https://github.com/bfren/docker-debian/blob/main/CHANGELOG.md).
- The S6 overlay is updated to `bfren/alpine-s6` 7.0.3, which makes no changes to the overlay - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

### Fixed

- README: the Quickstart is now numbered steps, with what each of S6's empty files does.

## [5.0.2] - 2026-11-10

### Changed

- Base image updated to `bfren/debian` 6.0.2, which updates Nushell to 0.117.0 - your own Nushell scripts may need
  changes - see the [Debian changelog](https://github.com/bfren/docker-debian/blob/main/CHANGELOG.md).
- The S6 overlay is updated to `bfren/alpine-s6` 7.0.2: the container keeps starting when `BF_TZ` cannot be set, and
  `bf-s6 svc launch` no longer hides `CURRENT_FILE` and `FILE_PWD` - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

## [5.0.1] - 2026-11-06

### Changed

- Base image updated to `bfren/debian` 6.0.1, which rebuilds BusyBox, figlet and Nushell - see the
  [Debian changelog](https://github.com/bfren/docker-debian/blob/main/CHANGELOG.md).
- The S6 overlay is updated to `bfren/alpine-s6` 7.0.1, which makes no changes to the overlay - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).

## [5.0.0] - 2026-11-05

### Changed

- **Breaking:** base image updated to `bfren/debian` 6.0.0 - see the
  [Debian changelog](https://github.com/bfren/docker-debian/blob/main/CHANGELOG.md). `bf env set` must now run as
  root.
- The S6 overlay is updated to `bfren/alpine-s6` 7.0.0 - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

[5.0.4]: https://github.com/bfren/docker-debian-s6/compare/v5.0.3...v5.0.4
[5.0.3]: https://github.com/bfren/docker-debian-s6/compare/v5.0.2...v5.0.3
[5.0.2]: https://github.com/bfren/docker-debian-s6/compare/v5.0.1...v5.0.2
[5.0.1]: https://github.com/bfren/docker-debian-s6/compare/v5.0.0...v5.0.1
[5.0.0]: https://github.com/bfren/docker-debian-s6/compare/v4.5.2...v5.0.0
