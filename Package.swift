import PackageDescription

let package = Package(
  name: "swiftup",
  targets: [
    Target(name: "SwiftupFramework", dependencies: ["libNix"]),
    Target(name: "swiftup", dependencies: ["libNix", "SwiftupFramework"])
  ],
  dependencies: [
  .Package(url: "https://github.com/mominul/Commander.git", majorVersion: 0),
  .Package(url: "https://github.com/mominul/Environment.git", Version(0, 7, 0)),
  .Package(url: "https://github.com/nsomar/Process.git", majorVersion: 0),
  .Package(url: "https://github.com/mominul/StringPlus.git", majorVersion: 1),
  ]
)
