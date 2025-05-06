import MCP

public extension Server {
    @discardableResult
    func withResources(
        _ handlers: [ResourceHandler]
    ) -> Self {
        withMethodHandler(ListResources.self) { parameters in
            .init(
                resources: handlers.map { $0.toResource() },
                nextCursor: parameters.cursor
            )
        }

        let handlerOf = handlers.reduce(into: [:]) {
            $0[$1.uri] = $1.handlerClosure
        }

        return withMethodHandler(ReadResource.self) { parameters in
            guard let handler = handlerOf[parameters.uri] else {
                throw MCPError.invalidParams("Invalid parameters: \(parameters)")
            }
            let content = try await handler(parameters.uri)
            return .init(contents: [content])
        }
    }
}


public struct ResourceHandler: Sendable, Identifiable {
    public init(
        name: String,
        uri: String,
        description: String? = nil,
        mimeType: String? = nil,
        handlerClosure: @escaping @Sendable (String) async throws -> Resource.Content
    ) {
        self.name = name
        self.uri = uri
        self.description = description
        self.mimeType = mimeType
        self.handlerClosure = handlerClosure
    }

    /// The resource name
    public let name: String
    /// The resource URI
    public let uri: String
    /// The resource description
    public let description: String?
    /// The resource MIME type
    public let mimeType: String?
    /// The resource handler
    public let handlerClosure: @Sendable (_ uri: String) async throws -> Resource.Content

    /// The tool's unique identifier (same as name).
    public var id: String { uri }

    public func toResource() -> Resource {
        .init(name: name, uri: uri, description: description, mimeType: mimeType)
    }
}
