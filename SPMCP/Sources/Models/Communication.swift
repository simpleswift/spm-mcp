import Foundation
import MCP
import SchemaMCP
import System

public struct Communication : ~Copyable{
    public let client: Client
    public let server: Server

    private let serverTransport: StdioTransport
    private let clientTransport: StdioTransport

    public let serverReadEnd: FileDescriptor
    public let clientWriteEnd: FileDescriptor
    public let clientReadEnd: FileDescriptor
    public let serverWriteEnd: FileDescriptor

    public init() throws {
        let clientToServer = try FileDescriptor.pipe()
        let serverToClient = try FileDescriptor.pipe()
        serverReadEnd = clientToServer.readEnd
        clientWriteEnd = clientToServer.writeEnd
        clientReadEnd = serverToClient.readEnd
        serverWriteEnd = serverToClient.writeEnd

        let serverTransport = StdioTransport(
            input: serverReadEnd,
            output: serverWriteEnd
        )
        self.serverTransport = serverTransport

        let server = Server(name: "Server", version: "1.0.0")
        self.server = server

        let clientTransport = StdioTransport(
            input: clientReadEnd,
            output: clientWriteEnd
        )
        self.clientTransport = clientTransport

        let client = Client(name: "Client", version: "1.0.0")
        self.client = client
    }
    
    public func setup() async throws {
        try await serverTransport.connect()
        try await clientTransport.connect()
        try await server.start(transport: serverTransport)
        try await client.connect(transport: clientTransport)
    }
    
    public func teardown() async {
        await server.stop()
        await client.disconnect()
        await serverTransport.disconnect()
        await clientTransport.disconnect()
    }

    deinit {
        try? serverReadEnd.close()
        try? clientWriteEnd.close()
        try? clientReadEnd.close()
        try? serverWriteEnd.close()
    }
}
