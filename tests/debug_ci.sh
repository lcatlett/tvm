#!/usr/bin/env bash
# Debug script for CI issues

set -euo pipefail

echo "=== CI Debug Information ==="
echo "Bash version: $BASH_VERSION"
echo "OS: $(uname -s)"
echo "Architecture: $(uname -m)"
echo "Working directory: $(pwd)"
echo "User: $(whoami)"
echo "Home: $HOME"
echo "PATH: $PATH"
echo

echo "=== Testing individual commands ==="

# Test plugins:status in isolation
echo "Testing plugins:status command:"
./bin/tvm plugins:status 2>&1 || echo "Exit code: $?"
echo

# Test plugins:migrate in isolation  
echo "Testing plugins:migrate command:"
./bin/tvm plugins:migrate 2>&1 || echo "Exit code: $?"
echo

# Test help command
echo "Testing help command:"
./bin/tvm help 2>&1 || echo "Exit code: $?"
echo

echo "=== Environment Variables ==="
env | grep -E "(TERMINUS|TVM|HOME|PATH)" | sort
echo

echo "=== File System Check ==="
echo "Current directory contents:"
ls -la
echo
echo "bin directory contents:"
ls -la bin/
echo

echo "=== Test Framework Check ==="
echo "Running single test function:"
source tests/test_framework.sh
source tests/test_terminus_vm.sh

# Set up test environment
setup_test_env

echo "Test environment set up. Running plugin commands test:"
test_plugin_commands || echo "Test failed with exit code: $?"

echo "Cleaning up test environment:"
cleanup_test_env

echo "=== Debug Complete ==="
