.PHONY: help build-rhel8 clean-dist

help:
	@echo "WeTTY Build Commands"
	@echo "===================="
	@echo ""
	@echo "  make build-rhel8   - Build RHEL 8 compatible NPM package"
	@echo "  make clean-dist    - Clean distribution files"
	@echo ""

build-rhel8:
	@echo "Building RHEL 8 package..."
	@./scripts/build-rhel8-package.sh

clean-dist:
	@echo "Cleaning dist directory..."
	@rm -rf dist/
	@echo "Done."
