#!/usr/bin/env bash
set -euo pipefail

if [[ "${OSTYPE:-}" != "darwin"* ]]; then
  echo "This setup script currently supports macOS only." >&2
  exit 1
fi

IDF_VERSION="${IDF_VERSION:-v5.5.2}"
ESP_ROOT="${ESP_ROOT:-$HOME/.espressif}"
IDF_DIR="${IDF_DIR:-$ESP_ROOT/esp-idf-$IDF_VERSION}"

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew not found. Install it first:" >&2
  echo "  /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\"" >&2
  exit 1
fi

brew install \
  git wget flex bison gperf python cmake ninja ccache dfu-util libusb libffi openssl@3

mkdir -p "$ESP_ROOT"
if [[ ! -d "$IDF_DIR/.git" ]]; then
  git clone --depth 1 --branch "$IDF_VERSION" --recursive \
    https://github.com/espressif/esp-idf.git "$IDF_DIR"
else
  git -C "$IDF_DIR" fetch --tags --depth 1 origin "$IDF_VERSION"
  git -C "$IDF_DIR" checkout "$IDF_VERSION"
  git -C "$IDF_DIR" submodule update --init --recursive
fi

"$IDF_DIR/install.sh" esp32s3

echo
echo "ESP-IDF installed. For current shell run:"
echo "  . \"$IDF_DIR/export.sh\""
echo "Then run from project root:"
echo "  idf.py set-target esp32s3"
echo "  idf.py build"
