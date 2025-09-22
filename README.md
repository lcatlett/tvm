# 🚀 Terminus Version Manager

> **The smart way to manage multiple Pantheon Terminus versions**

Never get locked into a single Terminus version again. Switch between Terminus 2.x, 3.x, and 4.x instantly without breaking your workflows or dealing with Homebrew conflicts.

[![Tests](https://github.com/pantheon-systems/terminus-vm/actions/workflows/test.yml/badge.svg)](https://github.com/pantheon-systems/terminus-vm/actions/workflows/test.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

## ✨ Why Developers Love TVM

**🎯 Perfect for teams** managing multiple Pantheon projects with different Terminus requirements
**⚡ Zero downtime** switching between versions - no reinstalls, no conflicts
**🔒 CI/CD ready** - pin exact versions for consistent deployments
**🛡️ Risk-free testing** - try new Terminus features without breaking production workflows

## 📋 Table of Contents

- [🚀 Terminus Version Manager](#-terminus-version-manager)
  - [✨ Why Developers Love TVM](#-why-developers-love-tvm)
  - [📋 Table of Contents](#-table-of-contents)
  - [🚀 Quick Start](#-quick-start)
  - [📦 Installation](#-installation)
    - [Prerequisites](#prerequisites)
    - [Method 1: Quick Install (Recommended)](#method-1-quick-install-recommended)
    - [Post-Installation Setup](#post-installation-setup)
  - [💡 Usage Examples](#-usage-examples)
    - [Basic Version Management](#basic-version-management)
    - [Advanced Usage](#advanced-usage)
    - [Team Workflows](#team-workflows)
  - [🎯 Why Use TVM?](#-why-use-tvm)
    - [**🔒 Version Lock-in Issues**](#-version-lock-in-issues)
    - [**🍺 Homebrew Conflicts**](#-homebrew-conflicts)
    - [**🚀 CI/CD Version Consistency**](#-cicd-version-consistency)
    - [**📜 Legacy Project Support**](#-legacy-project-support)
    - [**🧪 Testing and Development**](#-testing-and-development)
    - [**👥 Team Standardization**](#-team-standardization)
  - [🔧 How It Works](#-how-it-works)
  - [⚠️ Important Limitations](#️-important-limitations)
    - [**🐘 PHP Version Compatibility**](#-php-version-compatibility)
    - [**🔧 Missing PHP Extensions**](#-missing-php-extensions)
    - [**🖥️ System Dependencies**](#️-system-dependencies)
    - [**🔐 Pantheon Account Issues**](#-pantheon-account-issues)
    - [**🌐 Network and Firewall Issues**](#-network-and-firewall-issues)
    - [**⚡ Performance Issues**](#-performance-issues)
  - [🧪 Development \& Testing](#-development--testing)
    - [Running Tests](#running-tests)
    - [Test Coverage](#test-coverage)
    - [CI/CD Pipeline](#cicd-pipeline)
    - [Contributing](#contributing)
  - [📄 License](#-license)

## 🚀 Quick Start

```bash
# 1. Install TVM
./install.sh

# 2. Install your first Terminus version
terminus install latest

# 3. Switch versions instantly
terminus use 3.6.2    # Use specific version
terminus use 4        # Use latest 4.x
terminus use latest   # Use newest available

# 4. List installed versions
terminus list
```

**That's it!** TVM handles the rest automatically.

## 📦 Installation

### Prerequisites

- **PHP 7.4+** (PHP 8.1+ recommended for Terminus 4.x)
- **Git** (for repository operations)
- **curl** (for downloading PHAR files)

### Method 1: Quick Install (Recommended)

```bash
# Clone and install
git clone https://github.com/your-org/terminus-vm.git
cd terminus-vm
./install.sh
```

The installer will:
- ✅ Install TVM to `~/.local/bin`
- ✅ Check your PATH configuration
- ✅ Provide guidance for existing Terminus installations
- ✅ Ensure proper permissions

```bash
# Copy files manually
cp bin/terminus ~/.local/bin/
cp bin/terminus-vm ~/.local/bin/
chmod +x ~/.local/bin/terminus ~/.local/bin/terminus-vm

# Ensure ~/.local/bin is in your PATH
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Post-Installation Setup

```bash
# Import existing Terminus installation (optional)
terminus import /usr/local/bin/terminus 3.6.2

# Install your first version
terminus install latest

# Verify installation
terminus --version
```

## 💡 Usage Examples

### Basic Version Management

```bash
# Install specific versions
terminus install 4.0.3
terminus install 3.6.2
terminus install latest

# Switch between versions instantly
terminus use 4.0.3      # Use exact version
terminus use 4          # Use latest 4.x
terminus use 3          # Use latest 3.x
terminus use latest     # Use newest available

# List all installed versions
terminus list

# Show currently active version
terminus path
```

### Advanced Usage

```bash
# Bulk install multiple versions (>= 1.0.0)
terminus update --all

# Update to latest and switch automatically
terminus updates

# Use version manager commands directly
terminus-vm list
terminus-vm use 4.0.3

# Set custom storage directory
export TERMINUS_VM_DIR="$HOME/my-terminus-versions"
terminus install latest
```

### Team Workflows

```bash
# Lock project to specific version
echo "4.0.3" > .terminus-version
terminus use $(cat .terminus-version)

# CI/CD usage
terminus install 4.0.3
terminus use 4.0.3
terminus auth:login --machine-token=$PANTHEON_TOKEN
```

## 🎯 Why Use TVM?

### **🔒 Version Lock-in Issues**
- **Problem**: Official installation methods (Homebrew, standalone PHAR) lock you to a single version
- **TVM Solution**: Install and switch between multiple Terminus versions instantly
- **Use Case**: Test new features in Terminus 4.x while maintaining compatibility with legacy scripts using 3.x

### **🍺 Homebrew Conflicts**
- **Problem**: Homebrew updates can break existing workflows when Terminus updates automatically
- **TVM Solution**: Bypass Homebrew entirely for Terminus, maintaining full control over versions
- **Use Case**: Prevent surprise breakages during `brew upgrade` operations

### **🚀 CI/CD Version Consistency**
- **Problem**: Different environments may have different Terminus versions, causing script failures
- **TVM Solution**: Pin specific versions per project and ensure consistency across all environments
- **Use Case**: Lock CI pipelines to tested Terminus versions while allowing local development flexibility

### **📜 Legacy Project Support**
- **Problem**: Older projects may require older Terminus versions due to API changes or deprecated features
- **TVM Solution**: Maintain multiple versions simultaneously without conflicts
- **Use Case**: Support legacy Drupal 7 sites requiring Terminus 2.x alongside modern Drupal 10 projects

### **🧪 Testing and Development**
- **Problem**: Testing new Terminus features requires replacing your working installation
- **TVM Solution**: Install beta/RC versions alongside stable releases for safe testing
- **Use Case**: Evaluate new Terminus features without risking your production workflows

### **👥 Team Standardization**
- **Problem**: Team members using different Terminus versions leads to inconsistent behavior
- **TVM Solution**: Standardize on specific versions per project with easy switching
- **Use Case**: Ensure all developers use the same Terminus version for a given project

## 🔧 How It Works

**Simple and Transparent:**
- 📁 PHARs stored at `~/.terminus/phars/terminus-<version>.phar`
- 📝 Current version tracked in `~/.terminus/phars/current`
- 🎯 Smart command routing: TVM commands vs. Terminus passthrough
- ⚡ Zero-overhead execution via your system PHP binary

**Environment Variables:**
- `TERMINUS_VM_DIR` — Custom storage location (default: `~/.terminus/phars`)
- `TERMINUS_PHP` — PHP binary to use (default: `php`)
- `GITHUB_TOKEN` — Avoid API rate limits (optional)

## ⚠️ Important Limitations

While TVM handles Terminus version management effectively, it **cannot** resolve these underlying system issues:

### **🐘 PHP Version Compatibility**
- **Limitation**: TVM cannot fix PHP version mismatches between your system and Terminus requirements
- **Example**: Terminus 4.x requires PHP 8.1+, but your system has PHP 7.4
- **Solution**: Use tools like `phpenv`, `brew install php@8.1`, or Docker to manage PHP versions

### **🔧 Missing PHP Extensions**
- **Limitation**: TVM cannot install missing PHP extensions required by Terminus
- **Example**: Missing `php-curl`, `php-json`, or `php-mbstring` extensions
- **Solution**: Install required extensions via your system package manager (`apt`, `yum`, `brew`)
- **Check**: Run `terminus self:info` to see PHP configuration and missing extensions

### **🖥️ System Dependencies**
- **Limitation**: TVM cannot install system-level dependencies like Git, SSH, or SSL certificates
- **Example**: Git not installed, SSH keys not configured, or SSL certificate issues
- **Solution**: Install dependencies through your system package manager

### **🔐 Pantheon Account Issues**
- **Limitation**: TVM cannot resolve authentication, permissions, or account-related problems
- **Example**: Invalid machine tokens, insufficient site permissions, or suspended accounts
- **Solution**: Resolve through Pantheon dashboard or support channels

### **🌐 Network and Firewall Issues**
- **Limitation**: TVM cannot bypass corporate firewalls or network restrictions
- **Example**: Blocked GitHub API access, proxy configuration, or VPN requirements
- **Solution**: Configure network settings, proxies, or use alternative installation methods

### **⚡ Performance Issues**
- **Limitation**: TVM cannot improve slow Terminus operations or API timeouts
- **Example**: Slow site deployments, API rate limiting, or large file transfers
- **Solution**: These are typically Pantheon platform or network-related issues

## 🧪 Development & Testing

### Running Tests

Run the test suite locally:

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

The test suite includes **12 test cases** with **19+ assertions** covering:

- ✅ **Core Functionality**: Script existence, permissions, help commands
- ✅ **Version Management**: Install, switch, list, path operations
- ✅ **Environment Handling**: Custom directories, PHP binaries
- ✅ **Error Scenarios**: Invalid commands, missing versions
- ✅ **Installation Process**: PATH detection, conflict resolution
- ✅ **Cross-Platform**: Ubuntu and macOS compatibility

### CI/CD Pipeline

**Automated Testing** on every push and pull request:
- 🐧 **Ubuntu Linux** (multiple bash versions)
- 🍎 **macOS** (latest)
- 🧪 **Installation Testing** in clean environments
- ⚡ **Fast Execution** (~15 seconds)

### Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Add tests** for your changes
4. **Run tests**: `make test`
5. **Commit** your changes: `git commit -m 'Add amazing feature'`
6. **Push** to the branch: `git push origin feature/amazing-feature`
7. **Open** a Pull Request

## 📄 License

**MIT License** - see [LICENSE](LICENSE) file for details.

---

<div align="center">

**Made with ❤️ for the Pantheon community**

[Report Bug](https://github.com/your-org/terminus-vm/issues) • [Request Feature](https://github.com/your-org/terminus-vm/issues) • [Documentation](https://github.com/your-org/terminus-vm/wiki)

</div>
