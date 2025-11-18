#!/usr/bin/env bash
# Validate the RHEL 8 build setup

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "=== WeTTY RHEL 8 Build Validation ==="
echo ""

# Check Docker
echo -n "Checking Docker... "
if command -v docker &> /dev/null; then
    echo "✓ Found"
    docker --version
else
    echo "✗ Docker not found"
    exit 1
fi

echo ""

# Check required files
echo "Checking required files..."
REQUIRED_FILES=(
    "containers/rhel8-builder/Dockerfile"
    "scripts/build-rhel8-package.sh"
    "docker-compose.rhel8.yml"
    "docs/rhel8-build.md"
    "Makefile"
)

ALL_FOUND=true
for file in "${REQUIRED_FILES[@]}"; do
    if [ -f "$PROJECT_ROOT/$file" ]; then
        echo "  ✓ $file"
    else
        echo "  ✗ $file - MISSING"
        ALL_FOUND=false
    fi
done

if [ "$ALL_FOUND" = false ]; then
    echo ""
    echo "Some required files are missing!"
    exit 1
fi

echo ""
echo "Checking script permissions..."
SCRIPTS=(
    "scripts/build-rhel8-package.sh"
    "scripts/rhel8-quickstart.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -x "$PROJECT_ROOT/$script" ]; then
        echo "  ✓ $script (executable)"
    else
        echo "  ✗ $script (not executable)"
        chmod +x "$PROJECT_ROOT/$script"
        echo "    → Fixed permissions"
    fi
done

echo ""
echo "=== Validation Complete ==="
echo ""
echo "All checks passed! You're ready to build."
echo ""
echo "To build the RHEL 8 package, run:"
echo "  ./scripts/build-rhel8-package.sh"
echo ""
echo "Or use make:"
echo "  make build-rhel8"
echo ""
