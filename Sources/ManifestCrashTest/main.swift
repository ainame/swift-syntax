//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2023 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

@_spi(RawSyntax) @_spi(Testing) import SwiftParser
import SwiftSyntax

/// Standalone executable to test for crash that occurs on Linux musl when
/// parsing Package.swift-like manifests with platforms arrays containing
/// version tuples.
///
/// The crash manifests in the token consumer / string-literal path with SIGSEGV
/// due to invalid memory access, particularly on musl + ARM64.

func testPackagePlatformsV13DoesNotCrash() {
  print("Test 1: Minimal Package.swift with platform version...")
  let src = """
    let package = Package(
        platforms: [.macOS(.v13)]
    )
    """

  let tree = Parser.parse(source: src)
  assert(tree.statements.count > 0, "Expected non-empty parse tree")
  print("✓ Test 1 passed")
}

func testRealisticManifestDoesNotCrash() {
  print("Test 2: Realistic Package.swift manifest...")
  let src = """
    // swift-tools-version: 6.0
    import PackageDescription

    let package = Package(
        name: "X",
        platforms: [.macOS(.v13)],
        targets: []
    )
    """

  let tree = Parser.parse(source: src)
  assert(tree.statements.count > 0, "Expected non-empty parse tree")
  print("✓ Test 2 passed")
}

func testMultiplePlatformsDoesNotCrash() {
  print("Test 3: Multiple platform specifications...")
  let src = """
    let package = Package(
        platforms: [
            .macOS(.v13),
            .iOS(.v16),
            .watchOS(.v9)
        ]
    )
    """

  let tree = Parser.parse(source: src)
  assert(tree.statements.count > 0, "Expected non-empty parse tree")
  print("✓ Test 3 passed")
}

func testUnderscoreVersionStyleDoesNotCrash() {
  print("Test 4: Underscore version style (v10_15)...")
  let src = """
    let package = Package(
        platforms: [.macOS(.v10_15)]
    )
    """

  let tree = Parser.parse(source: src)
  assert(tree.statements.count > 0, "Expected non-empty parse tree")
  print("✓ Test 4 passed")
}

func testEmptyPlatformsArrayDoesNotCrash() {
  print("Test 5: Empty platforms array...")
  let src = """
    let package = Package(
        platforms: []
    )
    """

  let tree = Parser.parse(source: src)
  assert(tree.statements.count > 0, "Expected non-empty parse tree")
  print("✓ Test 5 passed")
}

// Run all tests
print("Running ManifestCrashTests...")
print("================================")

testPackagePlatformsV13DoesNotCrash()
testRealisticManifestDoesNotCrash()
testMultiplePlatformsDoesNotCrash()
testUnderscoreVersionStyleDoesNotCrash()
testEmptyPlatformsArrayDoesNotCrash()

print("================================")
print("All tests passed! ✓")
