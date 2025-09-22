# Terminus Version Manager Tests

This directory contains the test suite for the Terminus Version Manager.

## Test Structure

- `test_framework.sh` - Simple bash testing framework with colored output
- `test_terminus_vm.sh` - Main test suite with 12+ test cases
- `run_tests.sh` - Test runner script

## Running Tests

### Local Testing

```bash
# From project root
make test

# Or directly
./tests/run_tests.sh

# Test installation process
make test-install

# Clean up test artifacts
make clean
```

### GitHub Actions

Tests run automatically on:
- Push to main/master branch
- Pull requests to main/master branch
- Multiple platforms: Ubuntu and macOS
- Multiple bash versions (where available)

## Test Coverage

### Core Functionality
- ✅ Script file existence and permissions
- ✅ Help command output
- ✅ Path command functionality
- ✅ List command with no versions
- ✅ Version resolution logic
- ✅ terminus-vm wrapper script
- ✅ Environment variable customization
- ✅ Error handling for invalid commands
- ✅ @vm prefix functionality
- ✅ Manager command detection

### Installation Testing
- ✅ Install script existence and permissions
- ✅ Installation process simulation
- ✅ PATH detection and guidance
- ✅ Cross-platform compatibility

### CI/CD Testing
- ✅ Ubuntu Linux compatibility
- ✅ macOS compatibility
- ✅ PHP version compatibility
- ✅ Installation in clean environments

## Test Framework Features

- Colored output (green for pass, red for fail, yellow for running)
- Test counting and summary
- Multiple assertion types:
  - `assert_equals` - Exact string matching
  - `assert_contains` - Substring matching
  - `assert_not_contains` - Negative substring matching
  - `assert_file_exists` - File existence
  - `assert_file_executable` - File permissions
  - `assert_command_success` - Command exit codes
  - `assert_command_failure` - Expected failures

## Adding New Tests

1. Add test function to `test_terminus_vm.sh`:
```bash
test_new_feature() {
    test_start "New feature description"
    
    local output
    output="$(command_to_test 2>&1)"
    
    assert_contains "$output" "expected_string" "Test description"
}
```

2. Add function call to `run_all_tests()` function

3. Run tests to verify: `make test`

## Test Environment

Tests run in isolated temporary directories to avoid conflicts with:
- Existing Terminus installations
- User's actual ~/.terminus directory
- System PATH modifications

Each test gets a clean environment with:
- Temporary test directory (`/tmp/terminus-vm-test-$$`)
- Isolated TERMINUS_VM_DIR
- Modified PATH for testing
- Cleanup after completion
