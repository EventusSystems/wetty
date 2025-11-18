# RHEL 8 Build Setup - Summary

This document summarizes the RHEL 8 build infrastructure added to the WeTTY
fork.

## What Was Added

### 1. Docker Build System

- **`containers/rhel8-builder/Dockerfile`** - Multi-stage Dockerfile that:
  - Uses Rocky Linux 8 (RHEL 8 compatible) as base
  - Installs Node.js 20 and build tools
  - Compiles native modules for x86_64
  - Creates NPM package tarball
  - Exports package to host system

### 2. Build Scripts

- **`scripts/build-rhel8-package.sh`** - Main build script
  - Automatically builds the package using Docker
  - Outputs to `dist/` directory
  - Provides clear success/failure messages
- **`scripts/rhel8-quickstart.sh`** - Interactive test script
  - Builds and installs package locally for testing
  - Creates isolated test environment

### 3. Automation

- **`Makefile`** - Convenience targets:

  - `make build-rhel8` - Build the package
  - `make clean-dist` - Clean build artifacts

- **`docker-compose.rhel8.yml`** - Docker Compose configuration for building

- **`.github/workflows/build-rhel8.yml`** - GitHub Actions workflow:
  - Manual trigger available
  - Automatic build on version tags
  - Uploads artifacts to GitHub

### 4. Documentation

- **`docs/rhel8-build.md`** - Complete build guide covering:

  - Prerequisites
  - Build methods
  - Installation on RHEL 8
  - Publishing to private npm registry
  - Troubleshooting
  - CI/CD integration

- **`scripts/README.md`** - Script documentation

- **`README.md`** - Updated with RHEL 8 installation section

## Quick Start

```bash
# Build the package
./scripts/build-rhel8-package.sh

# Output will be in:
# dist/wetty-eventus-<version>.tgz
```

## Architecture

```
┌─────────────────────────────────────┐
│   macOS/Linux Build Machine         │
│   (Your Development Machine)        │
└──────────────┬──────────────────────┘
               │
               │ docker build
               ▼
┌─────────────────────────────────────┐
│   Rocky Linux 8 Container           │
│   (RHEL 8 Compatible)               │
│                                     │
│   1. Install Node.js 20             │
│   2. Install build tools            │
│   3. Build TypeScript → JavaScript  │
│   4. Compile native modules         │
│   5. Create npm tarball             │
└──────────────┬──────────────────────┘
               │
               │ export to host
               ▼
┌─────────────────────────────────────┐
│   dist/wetty-eventus-X.Y.Z.tgz      │
│   (Ready for RHEL 8 deployment)     │
└─────────────────────────────────────┘
               │
               │ deploy
               ▼
┌─────────────────────────────────────┐
│   RHEL 8 Production Machines        │
│   npm install <tarball>             │
└─────────────────────────────────────┘
```

## Deployment Options

### Option 1: Direct Installation

Copy the tarball to RHEL 8 machine:

```bash
npm install /path/to/wetty-eventus-<version>.tgz
```

### Option 2: Private NPM Registry

Publish to your private registry:

```bash
npm publish ./dist/wetty-eventus-<version>.tgz --registry=https://npm.example.com
```

Then on RHEL 8:

```bash
npm install wetty-eventus --registry=https://npm.example.com
```

### Option 3: GitHub Releases

Tag a release and the GitHub Action will automatically:

1. Build the RHEL 8 package
2. Attach it to the release
3. Make it available for download

## Key Features

✅ **RHEL 8 Compatible** - Built on Rocky Linux 8 (binary compatible with
RHEL 8) ✅ **Native Modules** - All native dependencies (node-pty, gc-stats)
compiled for x86_64 ✅ **Reproducible** - Docker ensures consistent builds
across environments ✅ **Automated** - GitHub Actions workflow available ✅
**Well Documented** - Comprehensive guides and examples ✅ **Production
Ready** - Includes only production dependencies

## Testing the Build

Before deploying to production:

```bash
# Run the quickstart script
./scripts/rhel8-quickstart.sh

# Or manually:
npm install dist/wetty-eventus-*.tgz
npx wetty --ssh-host=localhost
```

Open browser to http://localhost:3000/wetty

## Maintenance

### Updating Dependencies

1. Update `package.json`
2. Run `pnpm install`
3. Rebuild: `./scripts/build-rhel8-package.sh`
4. Test on RHEL 8 machine

### Version Bumps

1. Update version in `package.json`
2. Commit and tag: `git tag -a v2.7.2 -m "Version 2.7.2"`
3. Push tag: `git push origin v2.7.2`
4. GitHub Action will build and attach to release

### Customization

- **Different Linux Distribution**: Edit `containers/rhel8-builder/Dockerfile`
  base image
- **Different Node.js Version**: Modify NodeSource setup in Dockerfile
- **Additional Build Steps**: Add to Dockerfile build stage

## Troubleshooting

See `docs/rhel8-build.md` for detailed troubleshooting guide.

Common issues:

- **Out of memory**: Increase Docker memory allocation
- **Build failures**: Check Docker logs: `docker logs <container-id>`
- **Architecture mismatch**: Ensure `--platform linux/amd64` is used

## Support

- Fork Repository: https://github.com/EventusSystems/wetty
- Original Repository: https://github.com/butlerx/wetty
- Issues: https://github.com/EventusSystems/wetty/issues
