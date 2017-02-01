/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Glibc
import StringPlus
import libNix

enum DistributionType {
case release
case snapshot
}

struct Distribution {
  var arrayOfUrl = [String]()

  var versionName: String {
    return String(arrayOfUrl[arrayOfUrl.count-2].characters.dropFirst(6)) // I know! ;)
  }

  /* Returns the base file name of the distribution */
  var fileName: String {
    return String(arrayOfUrl.last!.characters.dropLast(7))
  }

  var downloadUrl = String()

  init(target: String) {
    if target.isUrl {
      // If the target is a URL, we need to split things that we need from the URL
      arrayOfUrl = target.characters.split(separator: "/").map(String.init)
      downloadUrl = target
    } else {
      makeDistributionFrom(version: target)
    }
  }

  init(type: DistributionType) {
    switch type {
    case .snapshot:
      snapshotToolchain()
    default:
      fatalError("Not Supported Distribution Type")
    }
  }

  mutating func makeDistributionFrom(version: String) {
    let osID = getPlatformID()
    let osIDN = osID.trimmingCharacters(in: ["."])
    let url = "https://swift.org/builds/swift-\(version)-release/\(osIDN)/swift-\(version)-RELEASE/swift-\(version)-RELEASE-\(osID).tar.gz"

    downloadUrl = url
    arrayOfUrl = url.characters.split(separator: "/").map(String.init)
  }

  mutating func snapshotToolchain() {
    let osID = getPlatformID()
    let osIDN = osID.trimmingCharacters(in: ["."])

    print("Getting information about latest snapshot release", color: .green)

    let output = try! run(program: "/usr/bin/curl", arguments: ["https://swift.org/download/"])
    var regex = RegularExpression(pattern: "\\/(builds)\\/(development)\\/(\(osIDN))\\/.+(\\.gz)")

    guard let matched = regex.getMatch(search: output) else {
      print("Failed to get information from swift.org", color: .red)
      exit(1)
    }

    let url = "https://swift.org/".addingPath(matched)

    downloadUrl = url
    arrayOfUrl = url.characters.split(separator: "/").map(String.init)
  }
}
