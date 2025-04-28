import ProjectDescription

let project = Project(
  name: "SPMCP",
  packages: [
    .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    .package(url: "https://github.com/swiftlang/swift-subprocess", .branch("main")),
    .package(url: "https://github.com/KeithBird/swift-sdk", .branch("main")),
    .package(url: "https://github.com/ajevans99/swift-json-schema", from: "0.0.0"),
    .package(url: "https://github.com/swift-server/swift-service-lifecycle", from: "2.0.0"),
    .package(url: "https://github.com/apple/swift-async-algorithms", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "MCPModel",
      destinations: .macOS,
      product: .staticLibrary,
      bundleId: "com.KeithBird.SPMCP.MCPModel",
      deploymentTargets: .macOS("14.0"),
      sources: ["SPMCP/Sources/**"],
      dependencies: [
        .package(product: "Logging", type: .runtime),
        .package(product: "Subprocess", type: .runtime),
        .package(product: "MCP", type: .runtime),
        .package(product: "JSONSchema", type: .runtime),
        .package(product: "JSONSchemaBuilder", type: .runtime),
      ]
    ),
    .target(
      name: "spmcp",
      destinations: .macOS,
      product: .commandLineTool,
      bundleId: "com.KeithBird.SPMCP.spmcp",
      deploymentTargets: .macOS("14.0"),
      sources: ["SPMCP/Commands/**"],
      dependencies: [
        .target(name: "MCPModel"),
        .package(product: "Logging", type: .runtime),
        .package(product: "ArgumentParser", type: .runtime),
        .package(product: "ServiceLifecycle", type: .runtime),
        .package(product: "AsyncAlgorithms", type: .runtime),
      ]
    ),
    .target(
      name: "SPMCPTests",
      destinations: .macOS,
      product: .unitTests,
      bundleId: "com.KeithBird.SPMCP.SPMCPTests",
      deploymentTargets: .macOS("14.0"),
      sources: ["SPMCP/Tests/**"],
      dependencies: [
        .target(name: "MCPModel"),
        .package(product: "MCP", type: .runtime),
        .package(product: "Logging", type: .runtime),
      ]
    ),
  ]
)
