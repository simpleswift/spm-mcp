import Foundation
import JSONSchema
import JSONSchemaBuilder
import Logging
import MCP
import SchemaMCP
import Subprocess
import System

public enum SPMCP {
    static let server = Server(
        name: "SPMCP",
        version: "1.0.0",
        capabilities: .init(
            logging: .init(),
            prompts: .init(),
            resources: .init(),
            tools: .init()
        )
    )
}

struct EmptyNoti: MCP.Notification {
    typealias Parameters = String
    static var name: String { "Empty" }
}

public extension SPMCP {
    static func run() async throws {
        let transport = StdioTransport()
        try await server.start(transport: transport)

        let toolBox: ToolBox = .init(tools: basicTool)
        await server.withTools(toolBox)

        await server.withMethodHandler(ListPrompts.self) { result in
            .init(prompts: [])
        }

        await server.withMethodHandler(ListResources.self) { result in
            .init(resources: [])
        }
    }

    static func stop() async {
        await server.stop()
    }
}

@Schemable
struct VoidInput {}

extension SPMCP {
    enum CLIOutput {
        case text(String)
        case error(String)
    }

    static func runInCLI(arguments: Arguments) async throws -> CallTool.Result {
        let result = try await Subprocess.run(
            .name("swift"),
            arguments: arguments,
            error: .string
        )

        let message = String(describing: result)
        if result.terminationStatus.isSuccess {
            return .init(content: [.text(message)], isError: true)
        } else {
            return .init(content: [.text(message)])
        }
    }
}

private let logger = Logger(label: "SPMCP")
