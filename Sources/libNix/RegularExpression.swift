/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

import Glibc

#if os(Linux)
  public let REG_EXTENDED: Int32 = 1
  public let REG_ICASE: Int32 = (REG_EXTENDED << 1)
  public let REG_NEWLINE: Int32 = (REG_ICASE << 1)
  public let REG_NOSUB: Int32 = (REG_NEWLINE << 1)
#endif

public struct RegularExpression {
  var regex = regex_t()

  public init(pattern: String) {
    regcomp(&regex, pattern, REG_EXTENDED|REG_NEWLINE)
  }

  public mutating func getMatch(search: String) -> String? {
    var match = regmatch_t()

    let status = regexec(&regex, search, 1, &match, 0)

    guard status == 0 else {
      return nil
    }

    let length = match.rm_eo - match.rm_so

    let matched = search.substring(start: Int(match.rm_so), length: Int(length))

    return matched
  }
}
