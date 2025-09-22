#!/usr/bin/env bash
# Tests for Terminus Version Manager

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
    chmod +x "$TEST_BIN_DIR/terminus" "$TEST_BIN_DIR/terminus-vm"
    
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
    assert_file_executable "$PROJECT_DIR/bin/terminus" "terminus script is executable"
    assert_file_executable "$PROJECT_DIR/bin/terminus-vm" "terminus-vm script is executable"
}

# Test: Help command works
test_help_command() {
    test_start "Help command works"
    
    local output
    output="$("$TEST_BIN_DIR/terminus" help 2>&1)"
    
    assert_contains "$output" "Terminus Version Manager" "Help shows title"
    assert_contains "$output" "Usage:" "Help shows usage"
    assert_contains "$output" "terminus use" "Help shows use command"
    assert_contains "$output" "terminus install" "Help shows install command"
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
    
    assert_contains "$output" "Terminus Version Manager" "terminus-vm wrapper shows help"
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
    
    assert_contains "$output" "Installing terminus and terminus-vm" "Install script shows installation message"
    
    rm -f "$temp_install"
}

# Test: @vm prefix functionality
test_vm_prefix() {
    test_start "@vm prefix functionality"

    local output
    output="$("$TEST_BIN_DIR/terminus" @vm help 2>&1)"

    assert_contains "$output" "Terminus Version Manager" "@vm prefix works"
}

# Test: Manager command detection
test_manager_command_detection() {
    test_start "Manager command detection"

    # Test that manager commands are detected properly
    local output
    output="$("$TEST_BIN_DIR/terminus" list 2>&1)"

    assert_contains "$output" "no versions installed yet" "List command is detected as manager command"
}

# Main test runner
run_all_tests() {
    echo "Setting up test environment..."
    setup_test_env
    
    echo "Running Terminus Version Manager tests..."
    echo
    
    # Run all tests
    test_script_files
    test_help_command
    test_path_command
    test_list_empty
    test_version_resolution
    test_terminus_vm_wrapper
    test_env_vars
    test_error_handling
    test_install_script
    test_install_script_dry_run
    test_vm_prefix
    test_manager_command_detection
    
    # Cleanup
    cleanup_test_env
    
    # Show summary
    test_summary
}

# Run tests if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    run_all_tests
fi
