/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Commander

func unimplemented() {
  print("Not implemented")
}

Group {
  $0.command("install") {
    unimplemented()
  }

  $0.command("show",
    description: "Show the active and installed toolchains"
  ) {
    unimplemented()
  }

  $0.command("upgrade") { (name:String) in
    unimplemented()
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
  } */
}.run()
