#!/usr/bin/env bash
# Simple test framework for bash scripts

set -euo pipefail

# Test framework variables
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0
TEST_OUTPUT=""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test framework functions
test_start() {
    local test_name="$1"
    echo -e "${YELLOW}Running: $test_name${NC}"
    TESTS_RUN=$((TESTS_RUN + 1))
}

test_pass() {
    local test_name="$1"
    echo -e "${GREEN}✓ PASS: $test_name${NC}"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

test_fail() {
    local test_name="$1"
    local message="${2:-}"
    echo -e "${RED}✗ FAIL: $test_name${NC}"
    if [ -n "$message" ]; then
        echo -e "${RED}  $message${NC}"
    fi
    TESTS_FAILED=$((TESTS_FAILED + 1))
}

assert_equals() {
    local expected="$1"
    local actual="$2"
    local test_name="$3"
    
    if [ "$expected" = "$actual" ]; then
        test_pass "$test_name"
    else
        test_fail "$test_name" "Expected: '$expected', Got: '$actual'"
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    if echo "$haystack" | grep -q "$needle"; then
        test_pass "$test_name"
    else
        test_fail "$test_name" "Expected '$haystack' to contain '$needle'"
    fi
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"
    local test_name="$3"
    
    if ! echo "$haystack" | grep -q "$needle"; then
        test_pass "$test_name"
    else
        test_fail "$test_name" "Expected '$haystack' to NOT contain '$needle'"
    fi
}

assert_file_exists() {
    local file="$1"
    local test_name="$2"
    
    if [ -f "$file" ]; then
        test_pass "$test_name"
    else
        test_fail "$test_name" "File '$file' does not exist"
    fi
}

assert_file_executable() {
    local file="$1"
    local test_name="$2"
    
    if [ -x "$file" ]; then
        test_pass "$test_name"
    else
        test_fail "$test_name" "File '$file' is not executable"
    fi
}

assert_command_success() {
    local command="$1"
    local test_name="$2"
    
    if eval "$command" >/dev/null 2>&1; then
        test_pass "$test_name"
    else
        test_fail "$test_name" "Command '$command' failed"
    fi
}

assert_command_failure() {
    local command="$1"
    local test_name="$2"
    
    if ! eval "$command" >/dev/null 2>&1; then
        test_pass "$test_name"
    else
        test_fail "$test_name" "Command '$command' should have failed"
    fi
}

# Test summary
test_summary() {
    echo
    echo "========================================="
    echo "Test Summary:"
    echo "  Total:  $TESTS_RUN"
    echo -e "  Passed: ${GREEN}$TESTS_PASSED${NC}"
    echo -e "  Failed: ${RED}$TESTS_FAILED${NC}"
    echo "========================================="
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        return 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        return 1
    fi
}
