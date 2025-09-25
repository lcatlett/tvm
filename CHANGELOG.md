# Changelog

All notable changes to TVM (Terminus Version Manager) will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- **Version-Specific Plugin Management**: Automatic management of plugin directories per Terminus major version
  - Plugin directories organized by major version (e.g., `~/.terminus/plugins-3.x`, `~/.terminus/plugins-4.x`)
  - Automatic symlink management when switching Terminus versions
  - Environment variables set for Terminus plugin discovery (`TERMINUS_PLUGINS_DIR`, `TERMINUS_DEPENDENCIES_DIR`)
  - One-time migration of existing plugins to version-specific structure
- **New Commands**:
  - `tvm plugins:status` - Show current plugin environment status
  - `tvm plugins:migrate` - Manually trigger plugin migration (runs automatically on first use)
- **Enhanced Help Documentation**: Updated help text to include plugin management information
- **Improved Test Coverage**: Added tests for plugin management functionality

### Changed
- **Plugin Directory Structure**: Plugins are now isolated per Terminus major version
- **Automatic Environment Setup**: Plugin environment is configured automatically when switching versions
- **Enhanced Version Switching**: `tvm use` now also sets up the appropriate plugin environment

### Fixed
- **Plugin Compatibility Issues**: Resolved conflicts when switching between Terminus versions with incompatible plugins
- **Shared Plugin Directory Problems**: Eliminated issues caused by shared plugin directories across versions

## [1.0.0] - Previous Release

### Added
- Initial TVM implementation
- Version management for Terminus PHARs
- Command aliases (`tvm`, `terminus`, `terminus-vm`)
- Smart command routing
- Environment variable support
- Installation script
- Comprehensive test suite
- CI/CD pipeline

### Features
- Install and switch between multiple Terminus versions
- Automatic version resolution (latest, major.minor, exact)
- Import existing Terminus installations
- Bulk version installation
- Cross-platform compatibility (macOS, Linux)
