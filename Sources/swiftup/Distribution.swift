/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

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

  mutating func makeDistributionFrom(version: String) {
    let osID = getPlatformID()
    let osIDN = String(osID.characters.filter { !($0 == ".") })
    let url = "https://swift.org/builds/swift-\(version)-release/\(osIDN)/swift-\(version)-RELEASE/swift-\(version)-RELEASE-\(osID).tar.gz"

    downloadUrl = url
    arrayOfUrl = url.characters.split(separator: "/").map(String.init)
  }
}
