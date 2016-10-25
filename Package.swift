import PackageDescription

let package = Package(
  name: "swiftup",
  dependencies: [
  .Package(url: "https://github.com/kylef/Commander.git", Version(0, 5, 0)),
  ]
)
