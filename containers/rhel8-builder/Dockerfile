# RHEL 8 Builder - Build wetty for RHEL 8 x86_64
# This Dockerfile creates an NPM package that can be installed on RHEL 8 machines

FROM rockylinux:8 AS base

# Install Node.js 20 (required by wetty) and build tools
RUN dnf install -y \
    gcc \
    gcc-c++ \
    make \
    python3 \
    git \
    && dnf clean all

# Install Node.js 20 from NodeSource
RUN curl -fsSL https://rpm.nodesource.com/setup_20.x | bash - \
    && dnf install -y nodejs \
    && dnf clean all

# Install pnpm globally
RUN npm install -g pnpm@9.4.0

WORKDIR /build/wetty

# Copy package files
COPY package.json pnpm-lock.yaml ./

# Install all dependencies (including dev dependencies for building)
RUN --mount=type=cache,id=pnpm-rhel8,target=/root/.pnpm-store \
    pnpm install --frozen-lockfile

# Copy source code
COPY . .

# Build the project
RUN pnpm run build

# Clean dev dependencies and reinstall only production dependencies
# Skip scripts to avoid husky install failing
RUN rm -rf node_modules && \
    pnpm install --prod --frozen-lockfile --ignore-scripts

# Rebuild only the native modules we need for production
RUN cd node_modules/node-pty && npm run install && cd ../..
RUN cd node_modules/.pnpm/gc-stats@1.4.1/node_modules/gc-stats && npm run install || true

# Remove the prepare script from package.json to avoid husky issues during pack
RUN node -e "const pkg = require('./package.json'); delete pkg.scripts.prepare; require('fs').writeFileSync('./package.json', JSON.stringify(pkg, null, 2));"

# Create the npm package tarball
RUN npm pack

# Create output directory
RUN mkdir -p /output && \
    mv wetty-eventus-*.tgz /output/ && \
    echo "Package created successfully!" && \
    ls -lh /output/

# Final stage to extract the package
FROM scratch AS export
COPY --from=base /output/* /
