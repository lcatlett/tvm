# Terminus Version Manager (PHAR)

Manage multiple versions of Pantheon Terminus (PHAR) side-by-side and switch instantly.

Features
- Keep Terminus PHARs under ~/.terminus/phars (configurable)
- Switch the active version: latest, major, major.minor, or exact
- Install a specific version or update to the latest
- Intercepts "terminus updates" to fetch the newest PHAR
- No Homebrew juggling; just a small shim before brew's Terminus in PATH
- Optional GitHub token support to avoid API rate limits

Quick start
1) Install
- From the extracted repo:

  ./install.sh

- Ensure ~/.local/bin is in your PATH (installer prints instructions if needed).

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

- Fetch a bunch of releases (first 200 tags):

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
- Make sure ~/.local/bin appears before /usr/local/bin in your PATH to override brew's terminus.
- You can always invoke the manager explicitly as "terminus-vm":

  terminus-vm list
  terminus-vm use 4

