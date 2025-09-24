#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"

echo "Installing TVM (tvm, terminus, terminus-vm) into $BIN_DIR ..."
mkdir -p "$BIN_DIR"
# Copy scripts
cp -f "bin/terminus" "$BIN_DIR/terminus"
cp -f "bin/terminus-vm" "$BIN_DIR/terminus-vm"
cp -f "bin/tvm" "$BIN_DIR/tvm"
chmod +x "$BIN_DIR/terminus" "$BIN_DIR/terminus-vm" "$BIN_DIR/tvm"

# Ensure storage dir exists
mkdir -p "${TERMINUS_VM_DIR:-$HOME/.terminus/phars}"

echo "Installed."

# PATH guidance (do not auto-modify shell rc)
case ":$PATH:" in
  *":$BIN_DIR:"*) HAVE_BIN_IN_PATH=1 ;;
  *) HAVE_BIN_IN_PATH=0 ;;
esac

# Check if there's an existing terminus that would take precedence
EXISTING_TERMINUS=""
if command -v terminus >/dev/null 2>&1; then
  EXISTING_TERMINUS="$(command -v terminus)"
fi

if [ "$HAVE_BIN_IN_PATH" -eq 0 ]; then
  echo
  echo "⚠️  $BIN_DIR is not in your PATH. Add it with:"
  echo "For zsh:"
  echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
  echo "For bash:"
  echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
elif [ -n "$EXISTING_TERMINUS" ] && [ "$EXISTING_TERMINUS" != "$BIN_DIR/terminus" ]; then
  echo
  echo "⚠️  Found existing terminus at: $EXISTING_TERMINUS"
  echo "This will take precedence over the version manager."
  echo "To use the version manager, ensure $BIN_DIR comes first in PATH:"
  echo "For zsh:"
  echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
  echo "For bash:"
  echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
  echo
  echo "Or use the version manager directly: $BIN_DIR/terminus"
else
  echo
  echo "✅ TVM is ready to use!"
fi

echo
echo "Tip: Import your existing Terminus PHAR if needed, e.g.:"
echo "  tvm import /usr/local/bin/terminus 3.6.2"
echo "Then switch: tvm use 3.6.2, or install new: tvm install 4.0.3"
