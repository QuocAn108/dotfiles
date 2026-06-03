# Changelog

All notable changes to Aero Weather are documented in this file.

The format is based on Keep a Changelog, and this project follows Semantic Versioning.

## [1.0.0] - 2026-03-30
### Added
- First public release of Aero Weather as a Plasma 6 weather widget fork.
- Desktop direct weather card mode as the default desktop presentation.
- Custom font color option in widget settings.
- User-facing loading/offline/error states with retry messaging during API fetch and network failures.
- Translation and locale packaging workflow aligned with current metadata and plugin domain.
- GPL-3.0 license text included in the repository.

### Changed
- Widget branding updated to Aero Weather across metadata and translation headers.
- Widget selection icon updated to a sun-and-cloud weather icon.
- Desktop weather card spacing and default dimensions tuned for cleaner visual layout.
- Package metadata aligned for Plasma 6-only support.

### Fixed
- Desktop geometry sync behavior improved to follow representation sizing changes.
- Forecast day label source stabilized to avoid undefined text assignments.
- Legacy translation domain artifacts cleaned up to avoid stale locale collisions.

[1.0.0]: https://github.com/xcurx/Aero-Weather/releases/tag/v1.0.0
