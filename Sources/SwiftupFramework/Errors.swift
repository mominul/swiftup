/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

public enum SwiftupError: Error, CustomStringConvertible {
  case installationError(description: String)
  case internalError(description: String)

  public var description: String {
    switch self {
    case let .installationError(description):
      return description
    case let .internalError(description):
      return description
    }
  }
}
