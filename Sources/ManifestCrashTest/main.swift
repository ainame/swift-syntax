import SwiftParser

let minimalCrashSource = """
  let package = Package(
      platforms: [.macOS(.v13)]
  )
  """

let realisticCrashSource = """
  // swift-tools-version: 6.0
  import PackageDescription

  let package = Package(
      name: "X",
      platforms: [.macOS(.v13)],
      targets: []
  )
  """

print("Testing minimal crash source...")
let tree1 = Parser.parse(source: minimalCrashSource)
print("✓ Minimal source parsed OK")

print("\nTesting realistic crash source...")
let tree2 = Parser.parse(source: realisticCrashSource)
print("✓ Realistic source parsed OK")

print("\nBoth tests passed!")
