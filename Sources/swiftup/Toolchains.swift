/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Foundation
import Environment

struct Toolchains {
  var versioningFolder: String {
    if let path = Env["SWIFTUP_ROOT"] {
      return path.addingPath("versions")
    }

    return ""
  }

  var globalVersion: String {
    get {
      return (try? String(contentsOfFile: Env["SWIFTUP_ROOT"]!.addingPath("version"), encoding: .utf8)) ?? ""
    }

    set {
      if isInstalled(version: newValue) {
        try? newValue.write(toFile: Env["SWIFTUP_ROOT"]!.addingPath("version"), atomically: true, encoding: .utf8)
      } else {
        print("Version \(newValue) is not installed!")
      }
    }
  }

  func installedVersions() -> [String]? {
    let paths = try? FileManager.default.contentsOfDirectory(atPath: versioningFolder)
    return paths
  }

  func isInstalled(version: String) -> Bool {
    if let versions = installedVersions() {
      return versions.contains {
        return ($0 == version) ? true : false
      }
    }

    return false
  }
}
