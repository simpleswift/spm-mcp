import MCP
import SchemaMCP
import Subprocess

extension SPMCP {
    private static let toolBox: ToolBox = .init(tools: (
        helpTool,
        basicTool,
        runTool
    ))

    static func registerTools() async {
        await server.withTools(toolBox)
    }
}

// MARK: - Resources

extension SPMCP {
    static func registerResources() async {
        await server.withMethodHandler(
            ListResources.self
        ) { parameters in
            .init(resources: [
                .init(
                    name: "man",
                    uri: "man/swift",
                    description: "Accessing detailed documentation for Swift CLI tools.",
                    mimeType: "text/plain"
                ),
            ])
        }

        await server.withMethodHandler(
            ReadResource.self
        ) { parameters in
            guard
                parameters.uri == "man/swift"
            else {
                return .init(contents: [])
            }

            let output = try await Subprocess.run(
                .name("man"),
                arguments: ["swift", "|", "col", "-bx"],
                error: .string
            )
            let message = String(describing: output)

            return .init(
                contents: [.text(
                    message,
                    uri: parameters.uri,
                    mimeType: "text/plain"
                )]
            )
        }
    }
}

extension SPMCP {
    static func registerPrompts() async {
        await server.withMethodHandler(
            ListPrompts.self
        ) { parameters in
            .init(prompts: [])
        }
    }
}
