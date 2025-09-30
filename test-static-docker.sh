#!/bin/bash
set -e

echo "================================"
echo "Building Docker image with Swift + static SDK"
echo "================================"

# Build the Docker image (this will be cached after first run)
docker build -f Dockerfile.static-test -t swift-syntax-static-test .

echo ""
echo "================================"
echo "Running ManifestCrashTest in Docker"
echo "================================"
echo ""

# Run the test in the container
docker run --rm -v "$(pwd):/workspace" swift-syntax-static-test

echo ""
echo "✓ All tests passed on Ubuntu 24.04 with static linking!"
