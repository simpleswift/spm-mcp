import Foundation
import JSONSchema
import JSONSchemaBuilder
import MCP

public extension Value {
  init(schema: some JSONSchemaComponent) throws {
    let data = try JSONEncoder().encode(schema.definition())
    self = try JSONDecoder().decode(Value.self, from: data)
  }
}

public extension JSONSchemaComponent {
  func parse(_ arguments: [String: Value]?) throws -> Output {
    let data = try JSONEncoder().encode(arguments)
    let string = String(data: data, encoding: .utf8) ?? ""
    return try parseAndValidate(instance: string)
  }
}

public struct SchemaTool<Schema: Schemable>: Identifiable {
  /// The tool name
  public let name: String
  /// The tool description
  public let description: String
  /// The tool input schema
  public let inputSchema: Schema.Type
  /// The tool handler
  public let handler: (Schema) async throws -> CallTool.Result

  public var id: String { name }

  public init(
    name: String,
    description: String,
    inputSchema: Schema.Type,
    handler: @escaping @Sendable (Schema) async throws -> CallTool.Result
  ) {
    self.name = name
    self.description = description
    self.inputSchema = inputSchema
    self.handler = handler
  }

  func toMCPTool() throws -> Tool {
    try .init(
      name: name,
      description: description,
      inputSchema: .init(schema: Schema.schema)
    )
  }
}
