import Glibc
import StringPlus

// This is only for compability...
public enum NixError: Error {
  case errorOccurred
  case fileOpenError
}

public func contentsOfDirectory(atPath path: String) throws -> [String] {
  var contents : [String] = [String]()

  let dir = opendir(path)

  if dir == nil {
    throw NixError.errorOccurred
  }

  defer {
    closedir(dir!)
  }

  while let entry = readdir(dir!) {
    let entryName = withUnsafePointer(to: &entry.pointee.d_name) {
      String(cString: UnsafeRawPointer($0).assumingMemoryBound(to: CChar.self))
    }
    // TODO: `entryName` should be limited in length to `entry.memory.d_namlen`.
    if entryName != "." && entryName != ".." {
      contents.append(entryName)
    }
  }

  return contents
}

public func getContentsOf(file: String) throws -> String {
  let fp = fopen(file, "r")

  if fp == nil {
    throw NixError.fileOpenError
  }

  let contents = UnsafeMutablePointer<CChar>.allocate(capacity: Int(BUFSIZ))
  defer {
    contents.deinitialize(count: Int(BUFSIZ))
    contents.deallocate(capacity: Int(BUFSIZ))
    fclose(fp)
  }
  fgets(contents, BUFSIZ, fp)
  return String(cString: contents)
}

public func writeTo(file: String, with: String) throws {
  let fp = fopen(file, "w")

  if fp == nil {
    throw NixError.errorOccurred
  }

  fputs(with, fp)
  fclose(fp)
}

public func fileExists(atPath path: String) -> Bool {
  var s = stat()
  if lstat(path, &s) >= 0 {
    // don't chase the link for this magic case -- we might be /Net/foo
    // which is a symlink to /private/Net/foo which is not yet mounted...
    if (s.st_mode & S_IFMT) == S_IFLNK {
      if (s.st_mode & S_ISVTX) == S_ISVTX {
        return true
      }
      // chase the link; too bad if it is a slink to /Net/foo
      stat(path, &s)
    }
  } else {
    return false
  }
  return true
}

public func createDirectory(atPath path: String) throws {
  if !fileExists(atPath: path) {
    let parent = path.deletingLastPathComponent
    if !fileExists(atPath: parent) {
      try createDirectory(atPath: parent)
    }

    if mkdir(path, S_IRWXU | S_IRWXG | S_IRWXO) != 0 {
      throw NixError.errorOccurred
    }
  }
}
