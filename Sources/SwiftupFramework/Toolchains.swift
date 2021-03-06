/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Glibc
import libNix
import Environment
import StringPlus

public struct Toolchains {
  var versioningFolder: String {
    if let path = Env["SWIFTUP_ROOT"] {
      return path.addingPath("versions")
    }

    return ""
  }

  public var globalVersion: String {
    get {
      //return (try? String(contentsOfFile: Env["SWIFTUP_ROOT"]!.addingPath("version"), encoding: .utf8)) ?? ""
      return (try? getContentsOf(file: Env["SWIFTUP_ROOT"]!.addingPath("version"))) ?? ""
    }

    set {
      if isInstalled(version: newValue) {
        //try? newValue.write(toFile: Env["SWIFTUP_ROOT"]!.addingPath("version"), atomically: true, encoding: .utf8)
        try? writeTo(file: Env["SWIFTUP_ROOT"]!.addingPath("version"), with: newValue)
      } else {
        print("Version \(newValue) is not installed!", color: .red)
      }
    }
  }

  public init() {
      //
  }

  public func installedVersions() -> [String]? {
    //let paths = try? FileManager.default.contentsOfDirectory(atPath: versioningFolder)
    let paths = try? contentsOfDirectory(atPath: versioningFolder)
    return paths
  }

  public func isInstalled(version: String) -> Bool {
    if let versions = installedVersions() {
      return versions.contains { $0 == version }
    }

    return false
  }

  public func getBinaryPath() -> String {
    return versioningFolder.addingPath(globalVersion).addingPath("usr/bin/")
  }

  public mutating func installToolchain(version: String) throws {
    try installToolchain(distribution: Distribution(target: version))
  }

  public mutating func installSnapshotToolchain() throws {
    try installToolchain(distribution: Distribution(type: .snapshot))
  }

  mutating func installToolchain(distribution: Distribution) throws {
    guard !isInstalled(version: distribution.versionName) else {
      print("Version \(distribution.versionName) is already installed!", color: .yellow)
      return
    }

    print("Will install version \(distribution.versionName)", color: .blue)
    try installTarToolchain(distribution: distribution)
    print("Version \(distribution.versionName) has been installed!")

    globalVersion = distribution.versionName
    rehashToolchain()
  }

  func installTarToolchain(distribution: Distribution) throws {
    let tempDir = getTempDir().addingPath("swiftup-\(distribution.versionName)")
    let tempFile = tempDir.addingPath("toolchain.tar.gz")
    let tempEFile = tempDir.addingPath("\(distribution.fileName)")
    let installDir = Toolchains().versioningFolder.addingPath("\(distribution.versionName)")

    // Create temp direcyory
    _ = try! createDirectory(atPath: tempDir)

    print("Downloading toolchain \(distribution.downloadUrl)", color: .white)

    let output = try run(program: "/usr/bin/curl", arguments: ["-C", "-", "\(distribution.downloadUrl)", "-o", "\(tempFile)"])
    print(output)

    guard fileExists(atPath: tempFile) else {
      throw SwiftupError.installationError(description: "Error occurred when downloading the toolchain")
    }

    try run(program: "/bin/tar", arguments: ["xzf", "\(tempFile)", "-C", "\(tempDir)"])

    guard fileExists(atPath: tempEFile) else {
      throw SwiftupError.installationError(description: "Error occurred when extracting the toolchain")
    }

    try moveItem(src: tempEFile, dest: installDir)

    guard fileExists(atPath: installDir) else {
      throw SwiftupError.installationError(description: "Error occurred when installing the toolchain")
    }
  }

  func rehashToolchain() {
    let binaryDir = versioningFolder.addingPath(globalVersion).addingPath("usr/bin")

    let binaries = try! contentsOfDirectory(atPath: binaryDir)

    func createShims(name: String) {
      let script = "#!/usr/bin/env bash\nset -e\nexec `swiftup which \(name)` $@\n"
      let shims = Env["SWIFTUP_ROOT"]!.addingPath("shims/\(name)")
      try! writeTo(file: shims, with: script)
      try! run(program: "/bin/chmod", arguments: ["+x", shims])
    }

    for binary in binaries {
      createShims(name: binary)
    }
  }
}
