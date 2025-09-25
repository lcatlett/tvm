# TVM - Terminus Version Manager

> **Switch Pantheon Terminus versions seamlessly - zero downtime, zero hassle**

Switch between Terminus 2.x, 3.x, and 4.x without breaking your workflows or dealing with Homebrew conflicts.

[![Tests](https://github.com/lcatlett/tvm/actions/workflows/test.yml/badge.svg)](https://github.com/lcatlett/tvm/actions/workflows/test.yml)

## Why Use TVM

- **Reproduce exact Terminus context** for scripts, CI/CD pipelines, and local testing
- **Essential for multi-project portfolios** managing different Terminus requirements
- **Zero downtime switching** - no reinstalls, no conflicts
- **CI/CD ready** - pin exact versions for consistent deployments
- **Risk-free testing** - try new features without breaking production workflows
- **Version-specific plugin management** - plugins automatically switch with Terminus versions
- Streamlines Terminus plugin and core development

## Table of Contents

- [Quick Start](#quick-start)
- [Installation](#installation)
- [Usage Examples](#usage-examples)
- [Use Cases](#use-cases)
- [How It Works](#how-it-works)
- [Command Aliases](#command-aliases)
- [Important Limitations](#important-limitations)
- [Development & Testing](#development--testing)

## Quick Start

```bash
# Install TVM
./install.sh

# Install your first Terminus version
tvm install latest

# Switch versions seamlessly
tvm use 3.6.2    # Use specific version
tvm use 4        # Use latest 4.x
tvm use latest   # Use newest available

# List installed versions
tvm list
```

## Installation

### Prerequisites

- **PHP 7.4+** (PHP 8.1+ recommended for Terminus 4.x)
- **Git** (for repository operations)
- **curl** (for downloading PHAR files)

### One-Liner Install

> **WARNING**: Always review scripts before executing them. Run at your own risk!

```bash
curl -fsSL https://raw.githubusercontent.com/lcatlett/tvm/master/install.sh | bash
```

### Method 1: Quick Install (Recommended)

```bash
# Clone and install
git clone https://github.com/lcatlett/tvm.git
cd tvm
./install.sh
```

The installer will:
- Install TVM to `~/.local/bin` (includes `tvm`, `terminus`, and `terminus-vm` commands)
- Check your PATH configuration
- Provide guidance for existing Terminus installations
- Ensure proper permissions

```bash
# Copy files manually
cp bin/tvm ~/.local/bin/
cp bin/terminus ~/.local/bin/
cp bin/terminus-vm ~/.local/bin/
chmod +x ~/.local/bin/tvm ~/.local/bin/terminus ~/.local/bin/terminus-vm

# Ensure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Post-Installation Setup

```bash
# Import existing Terminus installation (optional)
tvm import /usr/local/bin/terminus 3.6.2

# Install your first version
tvm install latest

# Verify installation
terminus --version
```

## Usage Examples

### Basic Version Management

```bash
# Install specific versions
tvm install 4.0.3
tvm install 3.6.2
tvm install latest

# Switch between versions instantly
tvm use 4.0.3      # Use exact version
tvm use 4          # Use latest 4.x
tvm use 3          # Use latest 3.x
tvm use latest     # Use newest available

# List all installed versions
tvm list

# Show currently active version
tvm path
```

### Advanced Usage

```bash
# Bulk install multiple versions (>= 1.0.0)
tvm update --all

# Update to latest and switch automatically
tvm updates

# Use different command aliases
tvm list           # Primary command (recommended)
terminus-vm list   # Direct manager access
terminus list      # Smart routing

# Set custom storage directory
export TERMINUS_VM_DIR="$HOME/my-terminus-versions"
tvm install latest
```

### Plugin Management

TVM automatically manages version-specific plugin directories to prevent compatibility issues:

```bash
# Check current plugin environment
tvm plugins:status

# View plugin directories for current version
tvm plugins:status
# Output:
# Current Terminus version: 3.6.2
# Major version: 3.x
# Plugin directory: ~/.terminus/plugins-3.x
# Dependencies directory: ~/.terminus/dependencies-3.x

# Switch versions - plugins automatically switch too
tvm use 4.0.3      # Now uses plugins-4.x directory
tvm use 3.6.2      # Now uses plugins-3.x directory

# Manually trigger plugin migration (runs automatically on first use)
tvm plugins:migrate
```

**How Plugin Management Works:**
- **Version-specific directories**: `~/.terminus/plugins-3.x`, `~/.terminus/plugins-4.x`, etc.
- **Automatic switching**: Plugin environment changes when you switch Terminus versions
- **Symlink management**: `~/.terminus/plugins` points to the correct version-specific directory
- **Seamless migration**: Existing plugins are automatically moved to version-specific directories

### Team Workflows

```bash
# Lock project to specific version
echo "4.0.3" > .terminus-version
tvm use $(cat .terminus-version)

# CI/CD usage
tvm install 4.0.3
tvm use 4.0.3
terminus auth:login --machine-token=$PANTHEON_TOKEN
```

## Use Cases

### Version Lock-in Issues
- **Problem**: Official installation methods lock you to a single version
- **Solution**: Install and switch between multiple Terminus versions seamlessly
- **Use Case**: Test new features in Terminus 4.x while maintaining legacy script compatibility

### Homebrew Conflicts
- **Problem**: Homebrew updates can break existing workflows
- **Solution**: Bypass Homebrew entirely, maintaining full version control
- **Use Case**: Prevent surprise breakages during `brew upgrade` operations

### CI/CD Version Consistency
- **Problem**: Different environments may have different Terminus versions
- **Solution**: Pin specific versions per project across all environments
- **Use Case**: Lock CI pipelines to tested versions while allowing local flexibility

### Legacy Project Support
- **Problem**: Older projects may require older Terminus versions
- **Solution**: Maintain multiple versions simultaneously without conflicts
- **Use Case**: Support legacy Drupal 7 sites alongside modern Drupal 10 projects

### Testing and Development
- **Problem**: Testing new features requires replacing your working installation
- **Solution**: Install beta/RC versions alongside stable releases
- **Use Case**: Evaluate new features without risking production workflows

### Team Standardization
- **Problem**: Team members using different versions leads to inconsistent behavior
- **Solution**: Standardize on specific versions per project with easy switching
- **Use Case**: Ensure all developers use the same Terminus version for a project

### Plugin Compatibility
- **Problem**: Plugins may not be compatible across major versions
- **Solution**: Automatic version-specific plugin management prevents conflicts
- **Use Case**: Use different plugin versions for Terminus 3.x vs 4.x automatically

## How It Works

**Simple and Transparent:**

- PHARs stored at `~/.terminus/phars/terminus-<version>.phar`
- Current version tracked in `~/.terminus/phars/current`
- Smart command routing: TVM commands vs. Terminus passthrough
- Zero-overhead execution via your system PHP binary

**Plugin Management:**

- Version-specific plugin directories: `~/.terminus/plugins-3.x`, `~/.terminus/plugins-4.x`
- Automatic symlink management: `~/.terminus/plugins` → version-specific directory
- Environment variables set for Terminus plugin discovery
- One-time migration of existing plugins to version-specific structure

**Environment Variables:**

- `TERMINUS_VM_DIR` — Custom storage location (default: `~/.terminus/phars`)
- `TERMINUS_PHP` — PHP binary to use (default: `php`)
- `GITHUB_TOKEN` — Avoid API rate limits (optional)
- `TERMINUS_PLUGINS_DIR` — Set automatically to version-specific plugin directory
- `TERMINUS_DEPENDENCIES_DIR` — Set automatically to version-specific dependencies directory

## Command Aliases

TVM provides multiple ways to access version management commands:

- **`tvm <command>`** - Primary command (recommended)
- **`terminus <command>`** - Smart routing (version management or Terminus execution)
- **`terminus-vm <command>`** - Direct access to version management commands

```bash
# These commands are equivalent:
tvm list           # Primary (recommended)
terminus list      # Smart routing
terminus-vm list   # Direct access

# All show installed versions:
* 3.6.2 (current)
  4.0.3

# Plugin management commands (TVM-specific):
tvm plugins:status     # Show current plugin environment
tvm plugins:migrate    # Migrate existing plugins (runs automatically)
```

## Important Limitations

While TVM handles Terminus version management effectively, it **cannot** resolve these underlying system issues:

### PHP Version Compatibility

- **Limitation**: TVM cannot fix PHP version mismatches between your system and Terminus requirements
- **Example**: Terminus 4.x requires PHP 8.1+, but your system has PHP 7.4
- **Solution**: Use tools like `phpenv`, `brew install php@8.1`, or Docker to manage PHP versions

### Missing PHP Extensions

- **Limitation**: TVM cannot install missing PHP extensions required by Terminus
- **Example**: Missing `php-curl`, `php-json`, or `php-mbstring` extensions
- **Solution**: Install required extensions via your system package manager (`apt`, `yum`, `brew`)
- **Check**: Run `terminus self:info` to see PHP configuration and missing extensions

### System Dependencies

- **Limitation**: TVM cannot install system-level dependencies like Git, SSH, or SSL certificates
- **Example**: Git not installed, SSH keys not configured, or SSL certificate issues
- **Solution**: Install dependencies through your system package manager

### Pantheon Account Issues

- **Limitation**: TVM cannot resolve authentication, permissions, or account-related problems
- **Example**: Invalid machine tokens, insufficient site permissions, or suspended accounts
- **Solution**: Resolve through Pantheon dashboard or support channels

### Network and Firewall Issues

- **Limitation**: TVM cannot bypass corporate firewalls or network restrictions
- **Example**: Blocked GitHub API access, proxy configuration, or VPN requirements
- **Solution**: Configure network settings, proxies, or use alternative installation methods

### Performance Issues

- **Limitation**: TVM cannot improve slow Terminus operations or API timeouts
- **Example**: Slow site deployments, API rate limiting, or large file transfers
- **Solution**: These are typically Pantheon platform or network-related issues

## Development & Testing

### Running Tests

```bash
# Run all tests
make test

# Or run tests directly
./tests/run_tests.sh

# Test the installation process
make test-install

# Clean up test artifacts
make clean
```

### Test Coverage

The test suite includes **14+ test cases** with **24+ assertions** covering:

- **Core Functionality**: Script existence, permissions, help commands
- **Version Management**: Install, switch, list, path operations
- **Plugin Management**: Version-specific plugin directories, symlink management
- **Command Aliases**: `terminus`, `terminus-vm`, and `tvm` command functionality
- **Environment Handling**: Custom directories, PHP binaries
- **Error Scenarios**: Invalid commands, missing versions
- **Installation Process**: PATH detection, conflict resolution
- **Cross-Platform**: Ubuntu and macOS compatibility

### CI/CD Pipeline

**Automated Testing** on every push and pull request:

- **Ubuntu Linux** (multiple bash versions)
- **macOS** (latest)
- **Installation Testing** in clean environments
- **Fast Execution** (~15 seconds)

### Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Add tests** for your changes
4. **Run tests**: `make test`
5. **Commit** your changes: `git commit -m 'Add amazing feature'`
6. **Push** to the branch: `git push origin feature/amazing-feature`
7. **Open** a Pull Request

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for a detailed history of changes, including the major plugin management enhancement.

## Disclaimer

**This project is not an official Pantheon product.** Terminus Version Manager (TVM) is a community-developed tool created to help developers manage multiple Terminus versions more effectively. This project is not affiliated with, endorsed by, or supported by Pantheon Systems, Inc. or the maintainers of Terminus.

For official Pantheon support and products, refer to the [Pantheon documentation](https://pantheon.io/docs).

---

**Made with ❤️ for the Pantheon community**

[Report Bug](https://github.com/lcatlett/tvm/issues) • [Request Feature](https://github.com/lcatlett/tvm/issues) • [Documentation](https://github.com/lcatlett/tvm/wiki)
