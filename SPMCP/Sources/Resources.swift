import MCP
import Subprocess
import UniformTypeIdentifiers

public enum ResourceURI: String, CaseIterable, Sendable {
    case manSwift = "cli://man/swift"
    case swiftVersion = "cli://swift/version"
    case help = "cli://help/swift"
    case buildHelp = "cli://help/build"
    case packageHelp = "cli://help/package"
    case runHelp = "cli://help/run"
    case testHelp = "cli://help/test"
    case replHelp = "cli://help/repl"
}

public extension [ResourceHandler] {
    static func make() -> Self {
        ResourceURI.makeHandlers()
    }
}

public extension ResourceURI {
    static func makeHandlers() -> [ResourceHandler] {
        allCases.map { uri in
            switch uri {
            case .manSwift:
                .init(
                    name: "man",
                    description: "Accessing detailed documentation for Swift CLI tools.",
                    uri: uri
                )
            case .swiftVersion:
                .init(
                    name: "swift-version",
                    description: "Get the version information of Swift installed on the system.",
                    uri: uri
                )
            case .help:
                .init(
                    name: "swift-help",
                    description: "Get descriptions of the available options and flags in Swift CLI.",
                    uri: uri
                )
            case .buildHelp:
                .init(
                    name: "build-help",
                    description: "Get more information about building Swift packages.",
                    uri: uri
                )
            case .packageHelp:
                .init(
                    name: "package-help",
                    description: "Get more information about creating and working on packages.",
                    uri: uri
                )
            case .runHelp:
                .init(
                    name: "run-help",
                    description: "Get more information about running a program from a package.",
                    uri: uri
                )
            case .testHelp:
                .init(
                    name: "test-help",
                    description: "Get more information about running package tests.",
                    uri: uri
                )
            case .replHelp:
                .init(
                    name: "repl-help",
                    description: "Get more information about experimenting with Swift code interactively.",
                    uri: uri
                )
            }
        }
    }

    var utType: UTType {
        .plainText
    }

    var command: [String] {
        switch self {
        case .manSwift:
            ["man", "swift"]
        case .swiftVersion:
            ["swift", "--version"]
        case .help:
            ["swift", "--help"]
        case .buildHelp:
            ["swift", "build", "--help"]
        case .packageHelp:
            ["swift", "package", "--help"]
        case .runHelp:
            ["swift", "run", "--help"]
        case .testHelp:
            ["swift", "test", "--help"]
        case .replHelp:
            ["swift", "repl", "--help"]
        }
    }

    @Sendable func fetch(_ uri: String) async throws -> Resource.Content {
        guard let first = command.first else {
            throw MCPError.invalidParams("Invalid parameters: \(rawValue)")
        }

        let output = try await Subprocess.run(
            .name(first),
            arguments: .init(Array(command.dropFirst())),
            error: .string
        )
        let message = String(describing: output)

        return .text(
            message,
            uri: rawValue,
            mimeType: utType.preferredMIMEType
        )
    }
}

public extension ResourceHandler {
    init(name: String, description: String, uri: ResourceURI) {
        self.init(
            name: name,
            uri: uri.rawValue,
            description: description,
            mimeType: uri.utType.preferredMIMEType,
            handlerClosure: uri.fetch
        )
    }
}
