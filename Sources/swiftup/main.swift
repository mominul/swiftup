/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Commander
import Environment

Group {
  $0.command("install",
    Argument<String>("version"),
    description: "Install specified version of toolchain"
  ) { version in
    let toolchain = Toolchains()
    toolchain.installToolchain(version: version)
  }

  $0.command("show",
    description: "Show the active and installed toolchains"
  ) {
    let toolchains = Toolchains()
    if let versions = toolchains.installedVersions() {
      versions.forEach {
        print($0)
      }
    } else {
      print("No installed versions found!")
    }
  }

  $0.command("global",
    Argument<String>("version"),
    description: "Set the global toolchain version") { version in
    var toolchain = Toolchains()
    toolchain.globalVersion = version
  }
/*
  $0.command("search",
    Flag("web", description: "Searches on cocoapods.org"),
    Argument<String>("query"),
    description: "Perform a search"
  ) { web, query in
    if web {
      print("Searching for \(query) on the web.")
    } else {
      print("Locally searching for \(query).")
    }
  }*/
}.run()
