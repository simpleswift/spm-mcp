import JSONSchemaBuilder
import SchemaMCP
import Subprocess

extension SPMCP {
    static let helpTool = SchemaTool(
        name: "help",
        description: "Get help with Swift commands and options.",
        inputType: HelpInput.self
    ) { input in
        try await runSwiftCmd(args: input.args)
    }
}

@Schemable
struct HelpInput: Sendable {
    @SchemaOptions(description: """
    Choose one of the following subcommands to get help:
    - versionFlag: Get the version information of Swift installed on the system.
    - help: Get descriptions of available options and flags.
    - buildHelp: Get more information about build Swift packages.
    - packageHelp: Get more information about create and work on packages.
    - runHelp: Get more information about run a program from a package.
    - testHelp: Get more information about run package tests.
    - replHelp: Get more information about experiment with Swift code interactively.
    """)
    let subCommand: HelpSubCmd
}

@Schemable
enum HelpSubCmd: Sendable {
    case versionFlag

    case help
    case buildHelp
    case packageHelp
    case runHelp
    case testHelp
    case replHelp
}

private extension HelpInput {
    var args: [String] {
        switch subCommand {
        case .versionFlag:
            ["--version"]
        case .help:
            ["help"]
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
