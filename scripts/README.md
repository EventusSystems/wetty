# WeTTY Build Scripts

This directory contains scripts for building and packaging WeTTY.

## RHEL 8 Package Builder

### `build-rhel8-package.sh`

Builds a RHEL 8 compatible NPM package using Docker.

**Usage:**

```bash
./scripts/build-rhel8-package.sh
```

**Output:**

- Creates `dist/wetty-eventus-<version>.tgz`
- Package is built for x86_64 architecture
- Native modules compiled for RHEL 8

**Requirements:**

- Docker

### `rhel8-quickstart.sh`

Interactive script that builds the package and sets up a local test
installation.

**Usage:**

```bash
./scripts/rhel8-quickstart.sh
```

This will:

1. Build the RHEL 8 package
2. Create a test directory at `/tmp/wetty-rhel8-test`
3. Install the package locally
4. Provide instructions for running WeTTY

**Requirements:**

- Docker
- Node.js (for testing)

## Using Make

You can also use the Makefile targets:

```bash
# Build RHEL 8 package
make build-rhel8

# Clean dist directory
make clean-dist
```

## CI/CD Integration

See `.github/workflows/build-rhel8.yml` for GitHub Actions integration.

The workflow:

- Can be triggered manually via workflow_dispatch
- Automatically runs on version tags (v\*)
- Uploads the package as a build artifact
- Attaches the package to GitHub releases (when triggered by tags)
