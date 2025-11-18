# Building WeTTY for RHEL 8

This guide explains how to build a RHEL 8 compatible NPM package for WeTTY that
can be installed on your RHEL 8 machines or published to your private NPM
registry.

## Prerequisites

- Docker installed on your build machine
- At least 2GB of free disk space
- Internet connection (for downloading dependencies)

## Quick Start

The easiest way to build the RHEL 8 package is using the provided build script:

```bash
./scripts/build-rhel8-package.sh
```

This will:

1. Build the package in a Rocky Linux 8 container (RHEL 8 compatible)
2. Compile native modules for x86_64 architecture
3. Create an NPM package tarball in the `./dist/` directory

## Build Output

After a successful build, you'll find the package in:

```
./dist/wetty-eventus-<version>.tgz
```

## Installing on RHEL 8 Machines

### Option 1: Direct Installation from Tarball

Copy the tarball to your RHEL 8 machine and install:

```bash
npm install -g /path/to/wetty-eventus-<version>.tgz
```

Or for a local project:

```bash
npm install /path/to/wetty-eventus-<version>.tgz
```

### Option 2: Publish to Private NPM Registry

First, publish the package to your private registry:

```bash
npm publish ./dist/wetty-eventus-<version>.tgz --registry=https://your-registry.example.com
```

Then on RHEL 8 machines, install normally:

```bash
npm install wetty-eventus --registry=https://your-registry.example.com
```

Or configure npm to always use your registry:

```bash
npm config set registry https://your-registry.example.com
npm install wetty-eventus
```

## Alternative Build Methods

### Using Docker Compose

```bash
docker-compose -f docker-compose.rhel8.yml build
docker-compose -f docker-compose.rhel8.yml up
```

The package will be available in `./dist/`

### Manual Docker Build

```bash
# Create output directory
mkdir -p dist

# Build and extract package
docker build \
  --platform linux/amd64 \
  -f containers/rhel8-builder/Dockerfile \
  -t wetty-rhel8-builder \
  --output type=local,dest=./dist \
  .
```

## System Requirements on RHEL 8

The WeTTY package requires the following on RHEL 8 machines:

- **Node.js**: >= 18.0.0 (Node 20 recommended)
- **Python**: 3.6+ (for node-gyp)
- **Build tools**: gcc, gcc-c++, make

To install prerequisites on RHEL 8:

```bash
# Install Node.js 20
curl -fsSL https://rpm.nodesource.com/setup_20.x | sudo bash -
sudo dnf install -y nodejs

# Install build tools (if not already present)
sudo dnf install -y gcc gcc-c++ make python3
```

## Verifying the Package

After building, you can inspect the package contents:

```bash
tar -tzf ./dist/wetty-eventus-<version>.tgz
```

To test the package locally before deploying:

```bash
# Create a test directory
mkdir -p /tmp/wetty-test
cd /tmp/wetty-test

# Install the package
npm install /path/to/dist/wetty-eventus-<version>.tgz

# Run WeTTY
npx wetty
```

## Troubleshooting

### Build Fails with "out of memory"

Increase Docker's memory allocation in Docker Desktop settings (recommended:
4GB+)

### Build Fails with "husky: command not found"

This has been fixed in the Dockerfile by removing the `prepare` script before
packaging. If you encounter this with an older version, update your Dockerfile
to the latest version.

### Native Module Compilation Errors

Ensure you're using the RHEL 8 builder which has all required build tools:

- gcc/g++
- Python 3
- make

### Package Size Too Large

The package includes native modules compiled for RHEL 8. Typical size: 50-100MB

### Architecture Mismatch

The build targets `linux/amd64` (x86_64). If you need ARM support, modify the
Dockerfile platform.

## CI/CD Integration

You can integrate this into your CI/CD pipeline:

```yaml
# Example GitHub Actions workflow
- name: Build RHEL 8 Package
  run: |
    ./scripts/build-rhel8-package.sh

- name: Upload to Artifact Storage
  uses: actions/upload-artifact@v3
  with:
    name: rhel8-package
    path: dist/*.tgz
```

## Customization

### Using Red Hat UBI Instead of Rocky Linux

Edit `containers/rhel8-builder/Dockerfile` and change the base image:

```dockerfile
FROM registry.access.redhat.com/ubi8/ubi:latest AS base
```

### Different Node.js Version

Modify the Dockerfile to use a different Node.js version:

```dockerfile
# Change setup_20.x to your desired version
RUN curl -fsSL https://rpm.nodesource.com/setup_18.x | bash -
```

## Support

For issues specific to this RHEL 8 build process, open an issue on:
https://github.com/EventusSystems/wetty/issues

For general WeTTY issues, refer to the upstream repository:
https://github.com/butlerx/wetty
