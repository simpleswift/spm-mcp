import JSONSchemaBuilder
import SchemaMCP
import Subprocess

extension SPMCP {
    static let basicTool = SchemaTool(
        name: "basic",
        description: "Run basic commands like build, package, run, test, and repl.",
        inputType: BasicInput.self
    ) { input in
        try await runSwiftCmd(args: input.args, at: input.packagePath)
    }
}

@Schemable
struct BasicInput: Sendable {
    @SchemaOptions(
        description: "Specify the package path to operate on (default current directory). This changes the working directory before any other operation.",
        examples: [
            "/Users/steven/Developer/spm-mcp",
        ]
    )
    let packagePath: String

    @SchemaOptions(description: """
    Choose one of the following subcommands to run:
    - build: Build Swift packages.
    - package: Create and work on packages.
    - run: Run a program from a package.
    - test: Run package tests.
    - repl: Experiment with Swift code interactively.
    """)
    let subCommand: BasicSubCmd
}

@Schemable
enum BasicSubCmd: Sendable {
    case build
    case package
    case run
    case test
    case repl
}

private extension BasicInput {
    var args: [String] {
        switch subCommand {
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
        }
    }
}
