import Subprocess
import System

public extension String {
  typealias UTF8Output = StringOutput<UTF8>

  init(describing instance: CollectedResult<UTF8Output, UTF8Output>) {
    let status = instance.terminationStatus
    if status.isSuccess {
      let error = instance.standardError ?? ""
      let output = instance.standardOutput ?? ""
      self.init(error + output)
    } else {
      let error = instance.standardError.map {
        "\n" + $0
      } ?? ""
      self.init(String(describing: status) + error)
    }
  }
}

private extension TerminationStatus.Code {
  var explanation: String {
    switch self {
    case 0: "Success"
    case 1: "General error"
    case 2: "Misuse of shell builtins"
    case 126: "Command invoked cannot execute"
    case 127: "Command not found"
    case 128: "Invalid exit argument"
    case 130: "Terminated by Ctrl+C (SIGINT)"
    case 137: "Terminated by SIGKILL (kill -9 or out-of-memory killer)"
    case 139: "Segmentation fault (SIGSEGV)"
    case 143: "Terminated by SIGTERM (graceful shutdown)"
    case 255: "Exit status out of range or abnormal termination"
    default: "Unknown"
    }
  }
}

public extension String {
  init(describing instance: TerminationStatus) {
    let str = switch instance {
    case let .exited(code):
      "Exit Code: \(code) (\(code.explanation))"
    case let .unhandledException(code):
      "Unhandled Exception Code: \(code) (\(code.explanation))"
    }
    self.init(str)
  }
}
