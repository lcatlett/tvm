#!/usr/bin/env bash
set -euo pipefail

PREFIX="${PREFIX:-$HOME/.local}"
BIN_DIR="$PREFIX/bin"

echo "Installing terminus and terminus-vm into $BIN_DIR ..."
mkdir -p "$BIN_DIR"
# Copy scripts
cp -f "bin/terminus" "$BIN_DIR/terminus"
cp -f "bin/terminus-vm" "$BIN_DIR/terminus-vm"
chmod +x "$BIN_DIR/terminus" "$BIN_DIR/terminus-vm"

# Ensure storage dir exists
mkdir -p "${TERMINUS_VM_DIR:-$HOME/.terminus/phars}"

echo "Installed."

# PATH guidance (do not auto-modify shell rc)
case ":$PATH:" in
  *":$BIN_DIR:"*) HAVE_BIN_IN_PATH=1 ;;
  *) HAVE_BIN_IN_PATH=0 ;;
esac

if [ "$HAVE_BIN_IN_PATH" -eq 0 ]; then
  echo
  echo "Add $BIN_DIR to your PATH. For zsh:"
  echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.zshrc && source ~/.zshrc"
  echo "For bash:"
  echo "  echo 'export PATH=\"$BIN_DIR:\$PATH\"' >> ~/.bashrc && source ~/.bashrc"
fi

echo
echo "Tip: Import your existing Terminus PHAR if needed, e.g.:"
echo "  terminus import /usr/local/bin/terminus 3.6.2"
echo "Then switch: terminus use 3.6.2, or install new: terminus install 4.0.3"
