import XCTest
@testable import PerfectPCRE2

class PerfectPCRE2Tests: XCTestCase {
  static var allTests = [
    ("testExample", testExample),
    ]
  func testExample() {
    do {
      let pattern = "([a-zA-Z]+)/([0-9.]+)\\s+([0-9]+)\\s+(.*)"
      let source = """
HTTP/1.1 100 continue
HTTP/1.0 200 OK
http/1.1  404 Not Found
Http/2.0  302   Forwarded
"""
      let lines = try source.pcre2Match(pattern: pattern)
      lines.forEach { line in
        print("================")
        print("full: $0", line[0])
        print("head: $1", line[1])
        print("vers: $2", line[2])
        print("code: $3", line[3])
        print("stat: $4", line[4])
      }
    } catch {
      XCTFail(error.localizedDescription)
    }
  }
}

