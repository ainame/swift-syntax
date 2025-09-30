#!/bin/bash
set -e

echo "================================"
echo "Testing ManifestCrashTest on Ubuntu 24.04 with static linking"
echo "================================"

# Build and run the test in Docker
docker run --rm -v "$(pwd):/workspace" -w /workspace ubuntu:24.04 bash -c '
set -e

echo "Step 1: Installing dependencies..."
apt-get update -qq
apt-get install -y -qq curl git build-essential libncurses-dev \
  unzip gnupg2 libcurl4-openssl-dev libpython3-dev libxml2-dev \
  libz3-dev pkg-config tzdata zlib1g-dev > /dev/null

echo "Step 2: Installing Swiftly..."
curl -sL -O https://download.swift.org/swiftly/linux/swiftly-$(uname -m).tar.gz
tar zxf swiftly-$(uname -m).tar.gz > /dev/null
./swiftly init --quiet-shell-followup --no-modify-profile
. "${SWIFTLY_HOME_DIR:-$HOME/.local/share/swiftly}/env.sh"
hash -r

echo "Step 3: Installing Swift main snapshot..."
swiftly install swift-DEVELOPMENT-SNAPSHOT-2025-09-07-a --assume-yes
swiftly use swift-DEVELOPMENT-SNAPSHOT-2025-09-07-a
. "${SWIFTLY_HOME_DIR:-$HOME/.local/share/swiftly}/env.sh"
hash -r

echo "Step 4: Verifying Swift version..."
swift --version

echo "Step 5: Installing static SDK snapshot..."
swift sdk install https://download.swift.org/development/static-sdk/swift-DEVELOPMENT-SNAPSHOT-2025-09-07-a/swift-DEVELOPMENT-SNAPSHOT-2025-09-07-a_static-linux-0.0.1.artifactbundle.tar.gz \
  --checksum 81a71e1357c444b845a37ad34f63a6585a9036ad184ae0c940e40b7286e8aa5b

echo "Step 6: Listing available SDKs..."
swift sdk list

echo "Step 7: Building ManifestCrashTest with static SDK..."
swift build -c release \
  --product ManifestCrashTest \
  --swift-sdk x86_64-swift-linux-musl

echo "Step 8: Verifying binary is statically linked..."
file .build/x86_64-swift-linux-musl/release/ManifestCrashTest
ldd .build/x86_64-swift-linux-musl/release/ManifestCrashTest 2>&1 || echo "✓ Binary is statically linked (no dynamic dependencies)"

echo ""
echo "Step 9: Running ManifestCrashTest..."
echo "================================"
.build/x86_64-swift-linux-musl/release/ManifestCrashTest
echo "================================"

echo ""
echo "✓ Test completed successfully!"
echo "✓ The parser does not crash on Linux musl with static linking."
'

echo ""
echo "✓ All tests passed on Ubuntu 24.04 with static linking!"
