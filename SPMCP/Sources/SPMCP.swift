import JSONSchemaBuilder
import Logging
import MCP
import Subprocess
import System

public extension SPMCP {
    static func run() async throws {
        let transport = StdioTransport()
        try await server.start(transport: transport)

        await registerTools()
        await registerPrompts()
        await registerResources()

        await server.waitUntilCompleted()
        await server.stop()
        await transport.disconnect()
    }
}

public enum SPMCP {
    static let server = Server(
        name: "SPMCP",
        version: "0.1.0",
        capabilities: .init(
            logging: .init(),
            prompts: .init(),
            resources: .init(),
            tools: .init()
        )
    )
}

@Schemable
struct VoidInput: Sendable {}

extension SPMCP {
    enum CLIOutput {
        case text(String)
        case error(String)
    }

    static func runSwiftCmd(
        args: [String], at path: String? = nil
    ) async throws -> CallTool.Result {
        let result = try await Subprocess.run(
            .name("swift"),
            arguments: .init(args),
            workingDirectory: path.map { .init($0) },
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
