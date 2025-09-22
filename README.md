# Terminus Version Manager (PHAR)

Manage multiple versions of Pantheon Terminus (PHAR) side-by-side and switch instantly.

## Problems This Solves

The Terminus Version Manager (TVM) addresses several common pain points with Terminus installation and management:

### **Version Lock-in Issues**
- **Problem**: Official installation methods (Homebrew, standalone PHAR) lock you to a single version
- **Solution**: Install and switch between multiple Terminus versions instantly
- **Use Case**: Test new features in Terminus 4.x while maintaining compatibility with legacy scripts using 3.x

### **Homebrew Conflicts**
- **Problem**: Homebrew updates can break existing workflows when Terminus updates automatically
- **Solution**: Bypass Homebrew entirely for Terminus, maintaining full control over versions
- **Use Case**: Prevent surprise breakages during `brew upgrade` operations

### **CI/CD Version Consistency**
- **Problem**: Different environments may have different Terminus versions, causing script failures
- **Solution**: Pin specific versions per project and ensure consistency across all environments
- **Use Case**: Lock CI pipelines to tested Terminus versions while allowing local development flexibility

### **Legacy Project Support**
- **Problem**: Older projects may require older Terminus versions due to API changes or deprecated features
- **Solution**: Maintain multiple versions simultaneously without conflicts
- **Use Case**: Support legacy Drupal 7 sites requiring Terminus 2.x alongside modern Drupal 10 projects

### **Testing and Development**
- **Problem**: Testing new Terminus features requires replacing your working installation
- **Solution**: Install beta/RC versions alongside stable releases for safe testing
- **Use Case**: Evaluate new Terminus features without risking your production workflows

### **Team Standardization**
- **Problem**: Team members using different Terminus versions leads to inconsistent behavior
- **Solution**: Standardize on specific versions per project with easy switching
- **Use Case**: Ensure all developers use the same Terminus version for a given project

## Features
- Keep Terminus PHARs under ~/.terminus/phars (configurable)
- Switch the active version: latest, major, major.minor, or exact
- Install a specific version or update to the latest
- Intercepts "terminus updates" to fetch the newest PHAR
- No Homebrew juggling; just a small shim before brew's Terminus in PATH
- Optional GitHub token support to avoid API rate limits

## What This Package Does NOT Solve

While TVM handles Terminus version management effectively, it **cannot** resolve these underlying system issues:

### **PHP Version Compatibility**
- **Limitation**: TVM cannot fix PHP version mismatches between your system and Terminus requirements
- **Example**: Terminus 4.x requires PHP 8.1+, but your system has PHP 7.4
- **Solution**: Use tools like `phpenv`, `brew install php@8.1`, or Docker to manage PHP versions
- **Note**: Each Terminus PHAR still requires a compatible PHP runtime on your system

### **Missing PHP Extensions**
- **Limitation**: TVM cannot install missing PHP extensions required by Terminus
- **Example**: Missing `php-curl`, `php-json`, or `php-mbstring` extensions
- **Solution**: Install required extensions via your system package manager (`apt`, `yum`, `brew`)
- **Check**: Run `terminus self:info` to see PHP configuration and missing extensions

### **System Dependencies**
- **Limitation**: TVM cannot install system-level dependencies like Git, SSH, or SSL certificates
- **Example**: Git not installed, SSH keys not configured, or SSL certificate issues
- **Solution**: Install dependencies through your system package manager
- **Note**: Terminus relies on these tools for repository operations and secure connections

### **Pantheon Account Issues**
- **Limitation**: TVM cannot resolve authentication, permissions, or account-related problems
- **Example**: Invalid machine tokens, insufficient site permissions, or suspended accounts
- **Solution**: Resolve through Pantheon dashboard or support channels
- **Note**: Version switching won't fix authentication failures

### **Network and Firewall Issues**
- **Limitation**: TVM cannot bypass corporate firewalls or network restrictions
- **Example**: Blocked GitHub API access, proxy configuration, or VPN requirements
- **Solution**: Configure network settings, proxies, or use alternative installation methods
- **Note**: TVM requires internet access to download PHAR files from GitHub

### **Terminus Command Compatibility**
- **Limitation**: TVM cannot make incompatible commands work across major version changes
- **Example**: Commands removed or changed between Terminus 2.x and 4.x
- **Solution**: Update scripts and workflows for the target Terminus version
- **Note**: Version switching is for compatibility, not command translation

### **Performance Issues**
- **Limitation**: TVM cannot improve slow Terminus operations or API timeouts
- **Example**: Slow site deployments, API rate limiting, or large file transfers
- **Solution**: These are typically Pantheon platform or network-related issues
- **Note**: Different Terminus versions may have different performance characteristics

## Installation

### Quick start
1) Install
- From the extracted repo:

  ./install.sh

- The installer will check your PATH and provide guidance if needed.
- If you have an existing Terminus installation, ensure ~/.local/bin comes first in your PATH.

2) Import your existing PHAR (optional)
- If you have a Terminus PHAR at /usr/local/bin/terminus:

  terminus import /usr/local/bin/terminus 3.6.2
  terminus use 3.6.2

3) Install and switch to Terminus 4.0.3

  terminus install 4.0.3
  terminus use 4.0.3
  terminus --version

Everyday usage
- Switch versions:

  terminus use 3
  terminus use 4
  terminus use 4.0
  terminus use 4.0.3
  terminus use latest

- Install a version (and switch to it):

  terminus install 4.0.3

- Update to the latest release and switch:

  terminus updates

- Fetch multiple releases (versions >= 1.0.0):

  terminus update --all

- List installed versions:

  terminus list

- Show which PHAR is active:

  terminus which

How it works
- PHARs live at ~/.terminus/phars as terminus-<version>.phar
- The "current" selection is recorded in ~/.terminus/phars/current
- The bin/terminus script:
  - If you run "terminus use/install/update/updates/list/versions/current/which/path/import", it handles the request itself
  - Otherwise it executes the selected PHAR via your PHP binary (default: php)

Configuration
- Environment variables:
  - TERMINUS_VM_DIR — where to store PHARs (default: ~/.terminus/phars)
  - TERMINUS_PHP — which PHP binary to use (default: php)
  - GITHUB_TOKEN — optional. Helps avoid GitHub API rate limits

Notes
- The installer will detect PATH conflicts and provide guidance.
- Make sure ~/.local/bin appears before /usr/local/bin in your PATH to override existing terminus installations.
- You can always invoke the manager explicitly as "terminus-vm":

  terminus-vm list
  terminus-vm use 4

- The `update --all` command intelligently filters versions to avoid download failures.

## Development

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

The test suite covers:
- Script file existence and permissions
- Help and basic command functionality
- Path and environment variable handling
- Version management commands
- Error handling
- Installation process
- Cross-platform compatibility

Tests run automatically on GitHub Actions for both Ubuntu and macOS.

