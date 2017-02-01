/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Glibc
import libNix
import Spawn
import Environment
import StringPlus

func unimplemented() {
  print("Not Implemented!")
  exit(1)
}

func getTempDir() -> String {
  return Env["TMPDIR"] ?? "/tmp"
}

@discardableResult
func run(program: String, arguments: [String]) throws -> String {
  var output = ""

  do {
    _ = try Spawn(args: [program] + arguments) {
      output += $0
    }
  } catch {
    throw SwiftupError.internalError(description: "\(error)")
  }

  return output
}

func moveItem(src: String, dest: String) throws {
  try run(program: "/bin/mv", arguments: ["\(src)", "\(dest)"])
}

func getPlatformID() -> String {
  var version = ""

  _ = try? Spawn(args: ["/usr/bin/lsb_release", "-ds"]) {
    version = $0
  }

  var regex = RegularExpression(pattern: "ubuntu[0-9]+\\.[0-9]+")
  return regex.getMatch(search: version.simplified().lowercased())!
}
