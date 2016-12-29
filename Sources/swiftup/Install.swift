/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Environment

func install(version: String) {
  let toolchain = Toolchains()
  var versionName = ""

  if version.isUrl {
    // If the version is a URL, we need to split the version name from the URL
    // It can be done with regex, but for now HACK!
    let versionArray = version.characters.split(separator: "/").map(String.init)
    versionName = String(versionArray[versionArray.count-2].characters.dropFirst(6)) // I know! ;)
  } else {
    versionName = version
  }

  guard !toolchain.isInstalled(version: versionName) else {
    print("Version \(version.isUrl ? versionName : version) is already installed!")
    return
  }

  print("Will install \(versionName)")
}
