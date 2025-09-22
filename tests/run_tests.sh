#!/usr/bin/env bash
# Test runner script for Terminus Version Manager

set -euo pipefail

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Terminus Version Manager Test Suite"
echo "=================================="
echo

# Check if we're in the right directory
if [ ! -f "$SCRIPT_DIR/../bin/terminus" ]; then
    echo "Error: Could not find terminus script. Please run from the project root or tests directory."
    exit 1
fi

# Run the main test suite
"$SCRIPT_DIR/test_terminus_vm.sh"

exit_code=$?

if [ $exit_code -eq 0 ]; then
    echo
    echo "🎉 All tests passed!"
else
    echo
    echo "❌ Some tests failed!"
fi

exit $exit_code
