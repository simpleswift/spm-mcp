import Foundation
import JSONSchema
import JSONSchemaBuilder
import MCP
import Subprocess
import System

@Schemable
struct HelloInputSchema {
  @SchemaOptions(description: "The name to say hello to", examples: "Kth")
  let name: String
}

public enum Module {
  public static func run() async throws {
    let (clientToServerRead, clientToServerWrite) = try FileDescriptor.pipe()
    let (serverToClientRead, serverToClientWrite) = try FileDescriptor.pipe()

    let (client, server) = try await connect(
      clientToServerRead: clientToServerRead,
      clientToServerWrite: clientToServerWrite,
      serverToClientRead: serverToClientRead,
      serverToClientWrite: serverToClientWrite
    )

    let tools: [SchemaTool] = [SchemaTool(
      name: "hello", description: "Say Hello", inputSchema: HelloInputSchema.self
    ) { args in
      .init(content: [.text("Hello, \(args.name)")], isError: false)
    }]

    await server.withMethodHandler(ListTools.self) { parameters in
      logger.info("Server Received: \(ListTools.name)\n")
      let mcpTools = try tools.map { try $0.toMCPTool() }
      return .init(tools: mcpTools, nextCursor: parameters.cursor)
    }
    let listToolResult = try await client.listTools()
    logger.info("Client Received:\n\(listToolResult.map { "\($0)" }.joined(separator: "\n"))\n\n")

    let toolNamed = tools.reduce(into: [:]) {
      $0[$1.name] = $1
    }
    await server.withMethodHandler(CallTool.self) { call in
      guard let tool = toolNamed[call.name] else {
        return CallTool.Result(content: [.text("Tool \(call.name) not found")], isError: true)
      }
      let schema = try tool.inputSchema.schema.parse(call.arguments)
      return try await tool.handler(schema)
    }
    let callResult = try await client.callTool(name: "hello", arguments: ["name": .string("kth")])
    logger.info("Client Received: \(callResult)")

    await server.stop()
    await client.disconnect()
    try? clientToServerRead.close()
    try? clientToServerWrite.close()
    try? serverToClientRead.close()
    try? serverToClientWrite.close()

    // let result = try await Subprocess.run(
    //   .name("swift"),
    //   arguments: ["version"],
    //   error: .string
    // )
    // logger.info("\n\(result)")
    // logger.info("\n\(String(describing: result))")
  }
}

private extension Module {
  static func connect(
    clientToServerRead: FileDescriptor,
    clientToServerWrite: FileDescriptor,
    serverToClientRead: FileDescriptor,
    serverToClientWrite: FileDescriptor
  ) async throws -> (Client, Server) {
    let serverTransport = StdioTransport(
      input: clientToServerRead,
      output: serverToClientWrite,
      logger: Logger(label: "Server")
    )
    let server = Server(name: "SPM", version: "1.0.0")
    try await server.start(transport: serverTransport)

    let clientTransport = StdioTransport(
      input: serverToClientRead,
      output: clientToServerWrite,
      logger: Logger(label: "Client")
    )
    let client = Client(name: "MyApp", version: "1.0.0")
    try await client.connect(transport: clientTransport)

    return (client, server)
  }
}

private extension Module {
  static func runClient() async throws {
    let client = Client(name: "MyApp", version: "1.0.0")

    // // Create a transport and connect
    let clientTransport = StdioTransport()
    try await client.connect(transport: clientTransport)

    let result = try await client.initialize()
    logger.info("\nClient Received \(result)")

    let tools = try await client.listTools()
    logger.info("\nClient Received \(tools)")
  }
}

import Logging

private let logger = Logger(label: "Module")
