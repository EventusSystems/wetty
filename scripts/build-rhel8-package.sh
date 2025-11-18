#!/usr/bin/env bash
# Build script for creating RHEL 8 compatible NPM package

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
OUTPUT_DIR="${PROJECT_ROOT}/dist"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== WeTTY RHEL 8 Package Builder ===${NC}"
echo ""

# Check if Docker is available
if ! command -v docker &> /dev/null; then
    echo -e "${RED}Error: Docker is not installed or not in PATH${NC}"
    exit 1
fi

# Clean up previous builds
echo -e "${YELLOW}Cleaning up previous builds...${NC}"
rm -rf "${OUTPUT_DIR}"
mkdir -p "${OUTPUT_DIR}"

# Build the Docker image and extract the package
echo -e "${YELLOW}Building package for RHEL 8 x86_64...${NC}"
docker build \
    --platform linux/amd64 \
    -f containers/rhel8-builder/Dockerfile \
    -t wetty-rhel8-builder \
    --output type=local,dest="${OUTPUT_DIR}" \
    "${PROJECT_ROOT}"

# Check if package was created
PACKAGE_FILE=$(ls "${OUTPUT_DIR}"/wetty-eventus-*.tgz 2>/dev/null | head -n 1)

if [ -z "$PACKAGE_FILE" ]; then
    echo -e "${RED}Error: Package file not found in ${OUTPUT_DIR}${NC}"
    exit 1
fi

PACKAGE_NAME=$(basename "$PACKAGE_FILE")

echo ""
echo -e "${GREEN}✓ Package built successfully!${NC}"
echo ""
echo -e "Package location: ${GREEN}${OUTPUT_DIR}/${PACKAGE_NAME}${NC}"
echo ""
echo "To install on RHEL 8 machine:"
echo -e "  ${YELLOW}npm install ${OUTPUT_DIR}/${PACKAGE_NAME}${NC}"
echo ""
echo "Or upload to your private npm registry:"
echo -e "  ${YELLOW}npm publish ${OUTPUT_DIR}/${PACKAGE_NAME} --registry=https://your-registry.example.com${NC}"
echo ""
