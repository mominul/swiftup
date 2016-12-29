/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Foundation

func run(program: String, arguments: [String]) {
  let pipe = Pipe()
  let task = Process()

  task.launchPath = program
  task.arguments = arguments
  task.standardOutput = pipe

  task.launch()
  task.waitUntilExit()

  let a = String(data: pipe.fileHandleForReading.readDataToEndOfFile(), encoding: .utf8)!

  print(a)
}

extension String {
  func addingPath(_ path: String) -> String {
    if (hasSuffix("/") && !path.hasPrefix("/")) || (!hasSuffix("/") && path.hasPrefix("/")) {
      return self + path
    } else {
      return self + "/" + path
    }
  }

  var isUrl: Bool {
    return hasPrefix("https://")
  }
}
