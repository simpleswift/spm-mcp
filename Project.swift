import ProjectDescription

let project = Project(
  name: "SPMCP",
  packages: [
    .package(url: "https://github.com/ajevans99/swift-json-schema", from: "0.0.0"),
    .package(url: "https://github.com/modelcontextprotocol/swift-sdk", from: "0.0.0"),
    .package(url: "https://github.com/swiftlang/swift-subprocess", .branch("main")),
    .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.0"),
    .package(url: "https://github.com/apple/swift-log", from: "1.0.0"),
  ],
  targets: [
    .target(
      name: "MCPModel",
      destinations: .macOS,
      product: .staticLibrary,
      bundleId: "com.KeithBird.SPMMCP.MCPModel",
      deploymentTargets: .macOS("14.0"),
      sources: ["Sources/**"],
      dependencies: [
        .package(product: "JSONSchema", type: .runtime),
        .package(product: "JSONSchemaBuilder", type: .runtime),
        .package(product: "MCP", type: .runtime),
        .package(product: "Subprocess", type: .runtime),
        .package(product: "Logging", type: .runtime),
        .package(product: "ArgumentParser", type: .runtime),
      ]
    ),
    .target(
      name: "smcp",
      destinations: .macOS,
      product: .commandLineTool,
      bundleId: "com.KeithBird.SPMMCP.smcp",
      deploymentTargets: .macOS("14.0"),
      sources: ["Commands/**"],
      dependencies: [
        .target(name: "MCPModel"),
        .package(product: "Logging", type: .runtime),
        .package(product: "ArgumentParser", type: .runtime),
      ]
    ),
  ]
)
