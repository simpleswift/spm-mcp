import Foundation
import JSONSchemaBuilder
import MCP
import MCPModel
import SchemaMCP
import Testing

@Schemable
struct EchoInput {
    @SchemaOptions(description: "The message to echo")
    let message: String
}

struct SPMCPTests: ~Copyable {
    let c: Communication

    init() throws {
        c = try .init()
    }

    @Test func hello() async throws {
        try await c.setup()

        let tool = SchemaTool(
            name: "echo",
            description: "Echo a message",
            inputType: EchoInput.self
        ) { input in
            .init(content: [.text(input.message)])
        }

        let toolBox = ToolBox(tools: tool)
        await c.server.withTools(toolBox)

        let tools = try await c.client.listTools()
        #expect(tools.tools.count == 1)
        #expect(tools.tools[0].name == "echo")
        #expect(tools.tools[0].description == "Echo a message")

        #expect(throws: Never.self) {
            let value = try Value(schema: EchoInput.schema)
            #expect(tools.tools[0].inputSchema == value)
        }

        await c.teardown()
    }
}
