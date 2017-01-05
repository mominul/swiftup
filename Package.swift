import PackageDescription

let package = Package(
  name: "swiftup",
  targets: [
    Target(name: "swiftup", dependencies: ["libNix"])
  ],
  dependencies: [
  .Package(url: "https://github.com/kylef/Commander.git", Version(0, 6, 0)),
  .Package(url: "https://github.com/mominul/Environment.git", Version(0, 7, 0)),
  .Package(url: "https://github.com/mominul/Spawn.git", majorVersion: 0),
  ]
)
