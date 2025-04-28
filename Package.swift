// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "spm-mcp",
  platforms: [
    .macOS("14.0"),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
    .package(url: "https://github.com/swiftlang/swift-subprocess", branch: "main"),
    .package(url: "https://github.com/KeithBird/swift-sdk", branch: "main"),
    .package(url: "https://github.com/ajevans99/swift-json-schema", from: "0.0.0"),
    .package(url: "https://github.com/swift-server/swift-service-lifecycle", from: "2.0.0"),
    .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "MCPModel",
      dependencies: [
        .product(name: "Logging", package: "swift-log"),
        .product(name: "Subprocess", package: "swift-subprocess"),
        .product(name: "MCP", package: "swift-sdk"),
        .product(name: "JSONSchema", package: "swift-json-schema"),
        .product(name: "JSONSchemaBuilder", package: "swift-json-schema"),
      ],
      path: "SPMCP/Sources"
    ),
    .executableTarget(
      name: "spmcp",
      dependencies: [
        .target(name: "MCPModel"),
        .product(name: "ArgumentParser", package: "swift-argument-parser"),
        .product(name: "Logging", package: "swift-log"),
        .product(name: "ServiceLifecycle", package: "swift-service-lifecycle"),
        .product(name: "AsyncAlgorithms", package: "swift-async-algorithms"),
      ],
      path: "SPMCP/Commands"
    ),
    .testTarget(
      name: "SPMCPTests",
      dependencies: [
        .target(name: "MCPModel"),
        .product(name: "MCP", package: "swift-sdk"),
        .product(name: "Logging", package: "swift-log"),
      ],
      path: "SPMCP/Tests"
    ),
  ]
)
