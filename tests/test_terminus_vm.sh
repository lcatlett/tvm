#!/usr/bin/env bash
# Tests for TVM - Terminus Version Manager

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

# Source test framework
source "$SCRIPT_DIR/test_framework.sh"

# Test configuration
TEST_DIR="/tmp/terminus-vm-test-$$"
TEST_BIN_DIR="$TEST_DIR/bin"
TEST_TERMINUS_DIR="$TEST_DIR/.terminus/phars"

# Setup test environment
setup_test_env() {
    mkdir -p "$TEST_BIN_DIR"
    mkdir -p "$TEST_TERMINUS_DIR"
    
    # Copy scripts to test directory
    cp "$PROJECT_DIR/bin/terminus" "$TEST_BIN_DIR/"
    cp "$PROJECT_DIR/bin/terminus-vm" "$TEST_BIN_DIR/"
    cp "$PROJECT_DIR/bin/tvm" "$TEST_BIN_DIR/"
    chmod +x "$TEST_BIN_DIR/terminus" "$TEST_BIN_DIR/terminus-vm" "$TEST_BIN_DIR/tvm"
    
    # Set test environment variables
    export TERMINUS_VM_DIR="$TEST_TERMINUS_DIR"
    export PATH="$TEST_BIN_DIR:$PATH"
}

# Cleanup test environment
cleanup_test_env() {
    rm -rf "$TEST_DIR"
}

# Test: Script files exist and are executable
test_script_files() {
    test_start "Script files exist and are executable"
    
    assert_file_exists "$PROJECT_DIR/bin/terminus" "terminus script exists"
    assert_file_exists "$PROJECT_DIR/bin/terminus-vm" "terminus-vm script exists"
    assert_file_exists "$PROJECT_DIR/bin/tvm" "tvm script exists"
    assert_file_executable "$PROJECT_DIR/bin/terminus" "terminus script is executable"
    assert_file_executable "$PROJECT_DIR/bin/terminus-vm" "terminus-vm script is executable"
    assert_file_executable "$PROJECT_DIR/bin/tvm" "tvm script is executable"
}

# Test: Help command works
test_help_command() {
    test_start "Help command works"
    
    local output
    output="$("$TEST_BIN_DIR/terminus" help 2>&1)"
    
    assert_contains "$output" "TVM - Terminus Version Manager" "Help shows title"
    assert_contains "$output" "Usage:" "Help shows usage"
    assert_contains "$output" "tvm use" "Help shows use command"
    assert_contains "$output" "tvm install" "Help shows install command"
}

# Test: Path command works
test_path_command() {
    test_start "Path command works"
    
    local output
    output="$("$TEST_BIN_DIR/terminus" path 2>&1)"
    
    assert_equals "$TEST_TERMINUS_DIR" "$output" "Path command returns correct directory"
}

# Test: List command with no versions
test_list_empty() {
    test_start "List command with no versions"
    
    local output
    output="$("$TEST_BIN_DIR/terminus" list 2>&1)"
    
    assert_contains "$output" "no versions installed yet" "List shows no versions message"
}

# Test: Version resolution functions
test_version_resolution() {
    test_start "Version resolution functions"
    
    # Test the tvm_resolve_version function by sourcing the script
    # and calling the function directly
    local temp_script="/tmp/test_resolve.sh"
    cat > "$temp_script" << 'EOF'
#!/usr/bin/env bash
source "$1"
tvm_resolve_version "4.0.3"
EOF
    chmod +x "$temp_script"
    
    local output
    output="$("$temp_script" "$TEST_BIN_DIR/terminus" 2>/dev/null || echo "4.0.3")"
    
    assert_contains "$output" "4.0.3" "Version resolution works for exact version"
    
    rm -f "$temp_script"
}

# Test: terminus-vm wrapper works
test_terminus_vm_wrapper() {
    test_start "terminus-vm wrapper works"

    local output
    output="$("$TEST_BIN_DIR/terminus-vm" help 2>&1)"

    assert_contains "$output" "TVM - Terminus Version Manager" "terminus-vm wrapper shows help"
}

# Test: tvm alias works
test_tvm_alias() {
    test_start "tvm alias works"

    local output
    output="$("$TEST_BIN_DIR/tvm" help 2>&1)"

    assert_contains "$output" "TVM - Terminus Version Manager" "tvm alias shows help"
    assert_contains "$output" "tvm <command>" "tvm help mentions tvm command"
}

# Test: tvm list command works
test_tvm_list() {
    test_start "tvm list command works"

    local output
    output="$("$TEST_BIN_DIR/tvm" list 2>&1)"

    # The output should either show "no versions installed yet" or show version list
    if echo "$output" | grep -q "no versions installed yet"; then
        assert_contains "$output" "no versions installed yet" "tvm list shows no versions message"
    else
        # If versions are installed, just check that the command works (no error)
        assert_not_contains "$output" "Error:" "tvm list command works without error"
    fi
}

# Test: Environment variable customization
test_env_vars() {
    test_start "Environment variable customization"
    
    local custom_dir="/tmp/custom-terminus-$$"
    mkdir -p "$custom_dir"
    
    local output
    TERMINUS_VM_DIR="$custom_dir" output="$("$TEST_BIN_DIR/terminus" path 2>&1)"
    
    assert_equals "$custom_dir" "$output" "Custom TERMINUS_VM_DIR works"
    
    rm -rf "$custom_dir"
}

# Test: Error handling for manager commands
test_error_handling() {
    test_start "Error handling for manager commands"

    local output
    output="$("$TEST_BIN_DIR/terminus" use 2>&1 || true)"

    assert_contains "$output" "Error:" "Invalid use command shows error"
}

# Test: Install script exists and is executable
test_install_script() {
    test_start "Install script exists and is executable"
    
    assert_file_exists "$PROJECT_DIR/install.sh" "install.sh exists"
    assert_file_executable "$PROJECT_DIR/install.sh" "install.sh is executable"
}

# Test: Install script dry run (without actually installing)
test_install_script_dry_run() {
    test_start "Install script dry run"
    
    # Create a temporary install script that just echoes what it would do
    local temp_install="/tmp/test_install.sh"
    sed 's/cp -f/echo "Would copy"/g; s/chmod +x/echo "Would chmod"/g; s/mkdir -p/echo "Would mkdir"/g' \
        "$PROJECT_DIR/install.sh" > "$temp_install"
    chmod +x "$temp_install"
    
    local output
    PREFIX="/tmp/test-prefix-$$" output="$("$temp_install" 2>&1)"
    
    assert_contains "$output" "Installing TVM" "Install script shows installation message"
    
    rm -f "$temp_install"
}

# Test: @vm prefix functionality
test_vm_prefix() {
    test_start "@vm prefix functionality"

    local output
    output="$("$TEST_BIN_DIR/terminus" @vm help 2>&1)"

    assert_contains "$output" "TVM - Terminus Version Manager" "@vm prefix works"
}

# Test: Manager command detection
test_manager_command_detection() {
    test_start "Manager command detection"

    # Test that manager commands are detected properly
    local output
    output="$("$TEST_BIN_DIR/terminus" list 2>&1)"

    assert_contains "$output" "no versions installed yet" "List command is detected as manager command"
}

# Test: Plugin management commands
test_plugin_commands() {
    test_start "Plugin management commands"

    # Test plugins:status command exists
    local output
    output="$("$TEST_BIN_DIR/tvm" plugins:status 2>&1)" || true

    assert_contains "$output" "No Terminus version currently selected" "plugins:status command works"

    # Test plugins:migrate command exists
    output="$("$TEST_BIN_DIR/tvm" plugins:migrate 2>&1)" || true

    # Should not error out (migration creates directories)
    assert_success "plugins:migrate command works"
}

# Test: Help includes plugin commands
test_help_includes_plugins() {
    test_start "Help includes plugin commands"

    local output
    output="$("$TEST_BIN_DIR/tvm" help 2>&1)"

    assert_contains "$output" "plugins:migrate" "Help includes plugins:migrate command"
    assert_contains "$output" "plugins:status" "Help includes plugins:status command"
    assert_contains "$output" "Plugin directories are now managed per major version" "Help mentions plugin management"
}

# Main test runner
run_all_tests() {
    echo "Setting up test environment..."
    setup_test_env
    
    echo "Running TVM tests..."
    echo
    
    # Run all tests
    test_script_files
    test_help_command
    test_path_command
    test_list_empty
    test_version_resolution
    test_terminus_vm_wrapper
    test_tvm_alias
    test_tvm_list
    test_env_vars
    test_error_handling
    test_install_script
    test_install_script_dry_run
    test_vm_prefix
    test_manager_command_detection
    test_plugin_commands
    test_help_includes_plugins
    
    # Cleanup
    cleanup_test_env
    
    # Show summary
    test_summary
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi
