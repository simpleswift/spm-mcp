import ArgumentParser
import AsyncAlgorithms
import Logging
import MCPModel
import ServiceLifecycle

actor MCPServer: Service {
    func run() async throws {
        try await SPMCP.run()
        for await _ in AsyncTimerSequence(
            interval: .seconds(60), clock: .continuous
        ) {
            logger.info("looping")
        }
        await SPMCP.stop()
    }
}

@main
struct MCPCommand: AsyncParsableCommand {
    mutating func run() async throws {
        let server = MCPServer()
        let group = ServiceGroup(
            services: [server],
            gracefulShutdownSignals: [.sigterm, .sigint],
            logger: Logger(label: "MCPCommand")
        )
        try await group.run()
    }
}

private let logger = Logger(label: "Command")
