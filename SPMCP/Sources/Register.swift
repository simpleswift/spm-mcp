import MCP
import SchemaMCP
import Subprocess

extension SPMCP {
    private static let toolBox: ToolBox = .init(tools: (
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
        await server.withResources(.make())
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
