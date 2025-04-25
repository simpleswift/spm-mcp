// import MCP
import Subprocess

public enum Module {
  public static func run() async throws {
    let result = try await Subprocess.run(
      .name("swift"),
      arguments: ["version"],
      error: .string
    )
    logger.info("\n\(result)")
    logger.info("\n\(String(describing: result))")
  }
}

import Logging

private let logger = Logger(label: "Module")
