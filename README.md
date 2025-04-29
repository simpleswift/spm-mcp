# SMPMCP

A Model Context Protocol (MCP) server that provides automation capabilities using Swift Package Manager (SPM).

## Config

### Mise

```json
{
  "mcpServers": {
    "spm": {
      "command": "mise",
      "args": [
        "x",
        "ubi:simple-swift/spm-mcp@latest",
        "--",
        "spmcp"
      ],
    }
  }
}
```

## Development

### Swift Package Manager

```bash
swift package resolve
swift build
swift run
```

### Generate `.xcworkspace`

1. Install Tuist

```bash
mise install tuist 
```

2. Generate the workspace

```bash
tuist generate
```

## License

MIT License. See [LICENSE](https://github.com/KeithBird/spm-mcp?tab=MIT-1-ov-file#readme) for details.
