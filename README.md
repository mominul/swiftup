# swiftup: the Swift toolchain installer

[![Build Status](https://travis-ci.org/mominul/swiftup.svg?branch=master)](https://travis-ci.org/mominul/swiftup)

**swiftup** allows you to easily install, and switch between multiple versions of [Swift](https://swift.org/).

This project is Swift version of [swiftenv](https://github.com/kylef/swiftenv).

## Installation
swiftup can be easily installed by running it in your shell:
```bash
eval "$(curl -s https://raw.githubusercontent.com/mominul/swiftup/master/install.sh)"
```
**Currently only Ubuntu is supported**

### Commands
#### install
To install a specific release of Swift, you can easily install it by specifying the version:
```
swiftup install 3.0.2
```
Now swiftup will install the 3.0.2 version of Swift.

To install the latest [**snapshot**](https://swift.org/download/#snapshots) version of Swift:
```
swiftup install snapshot
```

You can also install a specific version of snapshot by passing its download URL directly to swiftup install.
```
swiftup install https://swift.org/builds/development/ubuntu1610/swift-DEVELOPMENT-SNAPSHOT-2017-02-01-a/swift-DEVELOPMENT-SNAPSHOT-2017-02-01-a-ubuntu16.10.tar.gz
```
