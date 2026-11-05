# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [5.0.0] - 2026-11-05

### Changed

- **Breaking:** base image updated to `bfren/debian` 6.0.0 - see the
  [Debian changelog](https://github.com/bfren/docker-debian/blob/main/CHANGELOG.md). `bf env set` must now run as
  root.
- The S6 overlay is updated to `bfren/alpine-s6` 7.0.0 - see the
  [Alpine + S6 changelog](https://github.com/bfren/docker-alpine-s6/blob/main/CHANGELOG.md).
- Images are built and published by the shared `bfren/docker` build workflow (`build.yml`), replacing the separate
  `dev.yml` and `publish.yml` workflows.

[5.0.0]: https://github.com/bfren/docker-debian-s6/compare/v4.5.2...v5.0.0
