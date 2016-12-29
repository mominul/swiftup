/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Foundation
import Environment

extension String {
  func addingPath(_ path: String) -> String {
    if (self.hasSuffix("/") && !path.hasPrefix("/")) || (!self.hasSuffix("/") && path.hasPrefix("/")) {
      return self + path
    } else {
      return self + "/" + path
    }
  }
}

struct Toolchains {
  var versioningFolder: String {
    if let path = Env["SWIFTUP_ROOT"] {
      return path.addingPath("versions")
    }

    return ""
  }

  func installedVersions() -> [String]? {
    let paths = try? FileManager.default.contentsOfDirectory(atPath: versioningFolder)
    return paths
  }
}
