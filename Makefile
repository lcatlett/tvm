# Terminus Version Manager Makefile

.PHONY: test test-verbose install clean help

# Default target
help:
	@echo "Terminus Version Manager"
	@echo "======================="
	@echo ""
	@echo "Available targets:"
	@echo "  test         - Run all tests"
	@echo "  test-verbose - Run tests with verbose output"
	@echo "  install      - Install to ~/.local/bin"
	@echo "  clean        - Clean up test artifacts"
	@echo "  help         - Show this help message"

# Run tests
test:
	@echo "Running tests..."
	@./tests/run_tests.sh

# Run tests with verbose output
test-verbose:
	@echo "Running tests with verbose output..."
	@bash -x ./tests/run_tests.sh

# Install the scripts
install:
	@echo "Installing Terminus Version Manager..."
	@./install.sh

# Clean up test artifacts
clean:
	@echo "Cleaning up test artifacts..."
	@rm -rf /tmp/terminus-vm-test-*
	@rm -rf /tmp/test-prefix-*
	@rm -rf /tmp/custom-terminus-*
	@echo "Clean complete."

# Test installation process
test-install:
	@echo "Testing installation process..."
	@TEMP_PREFIX="/tmp/terminus-vm-install-test-$$(date +%s)" && \
	mkdir -p "$$TEMP_PREFIX" && \
	PREFIX="$$TEMP_PREFIX" ./install.sh && \
	echo "Testing installed version..." && \
	export PATH="$$TEMP_PREFIX/bin:$$PATH" && \
	terminus help | grep -q "Terminus Version Manager" && \
	echo "✅ Installation test passed" && \
	rm -rf "$$TEMP_PREFIX"
