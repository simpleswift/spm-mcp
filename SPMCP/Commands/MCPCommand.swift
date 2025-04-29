import ArgumentParser
import Logging
import MCPModel

@main
struct MCPCommand: AsyncParsableCommand {
    mutating func run() async throws {
        try await SPMCP.run()
    }
}

private let logger = Logger(label: "Command")
