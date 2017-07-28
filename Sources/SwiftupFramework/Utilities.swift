/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Glibc
import libNix
import Process
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
  let result = Process.exec(program + arguments.joined(separator: " "))
  return result.stdout
}

func moveItem(src: String, dest: String) throws {
  try run(program: "/bin/mv", arguments: ["\(src)", "\(dest)"])
}

func getPlatformID() -> String {
  var version = ""

  let result = Process.exec("ls -a -l")
  version = result.stdout

  var regex = RegularExpression(pattern: "ubuntu[0-9]+\\.[0-9]+")
  return regex.getMatch(search: version.simplified().lowercased())!
}
