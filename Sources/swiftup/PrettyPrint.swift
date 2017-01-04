/*
  swiftup
  The Swift toolchain installer

  Copyright (C) 2016-present swiftup Authors

  Authors:
    Muhammad Mominul Huque
*/

/* Actually copied from Commander */

import Glibc

func isAnsi() -> Bool {
  if let termType = getenv("TERM"), String(cString: termType).lowercased() != "dumb" &&
    isatty(fileno(stdout)) != 0 {
    return true
  } else {
    return false
  }
}

enum Color: UInt8, CustomStringConvertible {
  case reset = 0

  case black = 30
  case red
  case green
  case yellow
  case blue
  case magenta
  case cyan
  case white
  case `default`

  var description: String {
    return isAnsi() ? "\u{001B}[\(self.rawValue)m" : ""
  }
}

func print(_ msg: String, color: Color) {
  print("\(color)\(msg)\(Color.reset)")
}
