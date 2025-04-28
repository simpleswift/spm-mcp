import ArgumentParser
import MCPModel

@main
struct MCPCommand: AsyncParsableCommand {
  mutating func run() async throws {
    try await SPMCP.run()
  }
}

import Logging

private let logger = Logger(label: "Command")
