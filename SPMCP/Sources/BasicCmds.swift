import JSONSchemaBuilder
import SchemaMCP
import Subprocess

@Schemable
enum SwiftSubCmd: String {
    @SchemaOptions(description: "Get the version information of Swift installed on the system.")
    case versionFlag = "version"

    @SchemaOptions(description: "Get descriptions of available options and flags.")
    case help

    @SchemaOptions(description: "Build Swift packages.")
    case build

    @SchemaOptions(description: "Create and work on packages.")
    case package

    @SchemaOptions(description: "Run a program from a package.")
    case run

    @SchemaOptions(description: "Run package tests.")
    case test

    @SchemaOptions(description: "Experiment with Swift code interactively.")
    case repl

    @SchemaOptions(description: "Get more information about build Swift packages.")
    case buildHelp = "build-help"

    @SchemaOptions(description: "Get more information about create and work on packages.")
    case packageHelp = "package-help"

    @SchemaOptions(description: "Get more information about run a program from a package.")
    case runHelp = "run-help"

    @SchemaOptions(description: "Get more information about run package tests.")
    case testHelp = "test-help"

    @SchemaOptions(description: "Get more information about experiment with Swift code interactively.")
    case replHelp = "repl-help"
}

private extension SwiftSubCmd {
    var arguments: Arguments {
        switch self {
        case .versionFlag:
            ["--version"]
        case .help:
            ["help"]
        case .build:
            ["build"]
        case .package:
            ["package"]
        case .run:
            ["run"]
        case .test:
            ["test"]
        case .repl:
            ["repl"]
        case .buildHelp:
            ["build", "--help"]
        case .packageHelp:
            ["package", "--help"]
        case .runHelp:
            ["run", "--help"]
        case .testHelp:
            ["test", "--help"]
        case .replHelp:
            ["repl", "--help"]
        }
    }
}

extension SPMCP {
    static let basicTool = SchemaTool(
        name: "basic",
        description: "Run a basic command to get started, seek help, or retrieve version information.",
        inputType: SwiftSubCmd.self
    ) { input in
        try await runInCLI(arguments: input.arguments)
    }
}
