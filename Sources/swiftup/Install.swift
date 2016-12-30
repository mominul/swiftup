/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Foundation
import Environment

func makeUrl(version: String) -> String {
  unimplemented()
  return ""
}

func installToolchain(version: String) {
  let toolchain = Toolchains()
  var versionName = ""
  var versionUrl = ""
  var fileName = ""

  if version.isUrl {
    versionUrl = version
    // If the version is a URL, we need to split the version name from the URL
    // It can be done with regex, but for now HACK!
    let versionArray = version.characters.split(separator: "/").map(String.init)
    versionName = String(versionArray[versionArray.count-2].characters.dropFirst(6)) // I know! ;)
    fileName = String(versionArray.last!.characters.dropLast(7))
  } else {
    versionName = version
    versionUrl = makeUrl(version: version)
  }

  guard !toolchain.isInstalled(version: versionName) else {
    print("Version \(versionName) is already installed!")
    return
  }

  print("Will install \(versionName)")
  installTarToolchain(version: versionName, url: versionUrl, fileName: fileName)
}

func installTarToolchain(version: String, url: String, fileName: String) {
  let tempDir = getTempDir().addingPath("swiftup-\(version)")
  let tempFile = tempDir.addingPath("toolchain.tar.gz")
  let tempEFile = tempDir.addingPath("\(fileName)")
  let installDir = Toolchains().versioningFolder.addingPath("\(version)")

  // Create temp direcyory
  _ = try! FileManager.default.createDirectory(atPath: tempDir, withIntermediateDirectories: true)

  print("Downloading toolchain \(url)")

  run(program: "/usr/bin/curl", arguments: ["-C", "-", "\(url)", "-o", "\(tempFile)"])

  guard FileManager.default.fileExists(atPath: tempFile) else {
    print("Error occurred when downloading the toolchain")
    exit(1)
  }

  run(program: "/bin/tar", arguments: ["xzf", "\(tempFile)", "-C", "\(tempDir)"])

  guard FileManager.default.fileExists(atPath: tempEFile) else {
    print("Error occurred when extracting the toolchain")
    exit(1)
  }

  moveItem(src: tempEFile, dest: installDir)

  guard FileManager.default.fileExists(atPath: installDir) else {
    print("Error occurred when installing the toolchain")
    exit(1)
  }
}
