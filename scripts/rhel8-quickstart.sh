#!/usr/bin/env bash
# Quick example script showing how to build and test the RHEL 8 package

set -e

echo "=== WeTTY RHEL 8 Package - Quick Start Example ==="
echo ""
echo "This script will:"
echo "  1. Build the RHEL 8 compatible package"
echo "  2. Create a test directory"
echo "  3. Install the package locally"
echo "  4. Show you how to run it"
echo ""

read -p "Press Enter to continue or Ctrl+C to cancel..."

# Step 1: Build the package
echo ""
echo "Step 1: Building RHEL 8 package..."
./scripts/build-rhel8-package.sh

# Find the built package
PACKAGE_FILE=$(ls dist/wetty-eventus-*.tgz | head -n 1)

if [ -z "$PACKAGE_FILE" ]; then
    echo "Error: Package not found!"
    exit 1
fi

echo "Package built: $PACKAGE_FILE"

# Step 2: Create test directory
echo ""
echo "Step 2: Creating test directory..."
TEST_DIR="/tmp/wetty-rhel8-test"
rm -rf "$TEST_DIR"
mkdir -p "$TEST_DIR"
cd "$TEST_DIR"

# Step 3: Install package
echo ""
echo "Step 3: Installing package..."
npm install "$OLDPWD/$PACKAGE_FILE"

# Step 4: Instructions
echo ""
echo "=== Installation Complete! ==="
echo ""
echo "To run WeTTY:"
echo "  cd $TEST_DIR"
echo "  npx wetty --ssh-host=localhost"
echo ""
echo "Then open your browser to: http://localhost:3000/wetty"
echo ""
echo "To clean up this test:"
echo "  rm -rf $TEST_DIR"
echo ""
