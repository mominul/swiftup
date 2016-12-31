import Glibc

// This is only for compability...
enum NixError: Error {
  case errorOccurred
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
    throw NixError.errorOccurred
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
