// The Swift Programming Language
// https://docs.swift.org/swift-book
//
// Swift Argument Parser
// https://swiftpackageindex.com/apple/swift-argument-parser/documentation

import ArgumentParser
import MCPModel

@main
struct MCPCommand: AsyncParsableCommand {
  mutating func run() async throws {
    try await Module.run()
  }
}

import Logging

private let logger = Logger(label: "Command")
