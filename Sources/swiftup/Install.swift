/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import libNix
import Environment
import SwiftupFramework

func installToolchain(argument: String) {
  var toolchain = Toolchains()

  do {
    if argument == "snapshot" {
      try toolchain.installSnapshotToolchain()
    } else if argument == "default" {
      let version = try! getContentsOf(file: Env["PWD"]!.addingPath(".swift-version"))
      if version.simplified() == "snapshot" {
        try toolchain.installSnapshotToolchain()
      }
    } else {
      try toolchain.installToolchain(version: argument)
    }
  } catch let error as SwiftupError {
    print("\(error)", color: .red)
  } catch {
    fatalError("Unknown error occurred")
  }
}
