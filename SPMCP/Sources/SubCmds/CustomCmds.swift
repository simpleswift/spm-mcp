import JSONSchemaBuilder
import SchemaMCP
import Subprocess

extension SPMCP {
    static let runTool = SchemaTool(
        name: "run",
        description: "Run a custom swift command",
        inputType: CmdInput.self
    ) { input in
        if let args = input.args {
            try await runSwiftCmd(
                args: args,
                at: input.packagePath
            )
        } else {
            .init(content: [.text("Invalid command: `\(input.command)`")], isError: true)
        }
    }
}

@Schemable
struct CmdInput: Sendable {
    @SchemaOptions(
        description: "Specify the package path to operate on (default current directory). This changes the working directory before any other operation.",
        examples: [
            "~/Developer/spm-mcp",
        ]
    )
    let packagePath: String

    @SchemaOptions(
        description: "The swift command to run",
        examples: [
            "swift test list",
            "swift package resolve",
            "swift package add-dependency https://github.com/modelcontextprotocol/swift-sdk --from 0.0.0",
        ]
    )
    let command: String
}

private extension CmdInput {
    var args: [String]? {
        let args = command.split(separator: " ").map(String.init)
        guard
            let first = args.first, first == "swift"
        else {
            return nil
        }
        return Array(args.dropFirst())
    }
}
