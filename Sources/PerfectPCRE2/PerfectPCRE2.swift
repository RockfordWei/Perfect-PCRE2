import pcre2api
import Foundation

public class PCRE2 {

  /// options for creating a pattern
  public enum OptionPattern: UInt32 {

    /// match only at the first position
    case anchored = 0x80000000

    /// do not check UTF validity
    case noUTFCheck = 0x40000000

    /// pattern can match only at end of subject
    case endanchored = 0x20000000

    /// Allow empty classes
    case allowEmptyClass = 0x00000001

    /// Alternative handling of \u, \U, and \x
    case altBsux = 0x00000002

    /// Compile automatic callouts
    case autoCallout = 0x00000004

    /// Do caseless matching
    case caseless = 0x00000008

    /// $ not to match newline at end
    case dollarEndonly = 0x00000010

    /// . matches anything including NL
    case dotall = 0x00000020

    /// Allow duplicate names for subpatterns
    case dupnames = 0x00000040

    /// Ignore white space and # comments
    case extended = 0x00000080

    /// Force matching to be before newline
    case firstline = 0x00000100

    /// Match unset back references
    case matchUnsetBackref = 0x00000200

    /// ^ and $ match newlines within data
    case multiline = 0x00000400

    /// Lock out PCRE2_UCP, e.g. via (*UCP)
    case neverUCP = 0x00000800

    /// Lock out PCRE2_UTF, e.g. via (*UTF)
    case neverUTF = 0x00001000

    /// Disable numbered capturing paren-theses (named ones available)
    case noAutoCapture = 0x00002000

    /// Disable auto-possessification
    case noAutoPossess = 0x00004000

    /// Disable automatic anchoring for .*
    case noDotstarAnchor = 0x00008000

    /// Disable match-time start optimizations
    case noStartOptimize = 0x00010000

    /// Use Unicode properties for \d, \w, etc.
    case UCP = 0x00020000

    /// Invert greediness of quantifiers
    case ungreedy = 0x00040000

    /// Treat pattern and subjects as UTF strings
    case UTF = 0x00080000

    /// Lock out the use of \C in patterns
    case neverBackslashC = 0x00100000

    /// Alternative handling of ^ in multiline mode
    case altCircumflex = 0x00200000

    /// Process backslashes in verb names
    case altVerbnames = 0x00400000

    /// Enable offset limit for unanchored matching
    case useOffsetLimit = 0x00800000

    case extendedMore = 0x01000000

    ///  Pattern characters are all literal
    case literal = 0x02000000
  }

  /// options for matching
  public enum OptionMatch: UInt32 {
    /// match only at the first position
    case anchored = 0x80000000

    /// Do not check the subject for UTF validity
    /// (only relevant if PCRE2_UTF was set at compile time)
    case noUTFCheck = 0x40000000

    /// pattern can match only at end of subject
    case endanchored = 0x20000000

    /// subject string is not the beginning of a line
    case notBOL = 0x00000001

    /// subject string is not the end of a line
    case notEOL = 0x00000002

    /// an empty string is not a valid match
    case notEmpty = 0x00000004

    /// an empty string at the start of the subject is not a valid match
    case notEmptyAtStart = 0x00000008

    /// return pcre2_error_partial for a partial match even if there is a full match
    case partialSoft = 0x00000010

    /// return pcre2_error_partial for a partial match if no full matches are found
    case partialHard = 0x00000020
  }

  public enum Exception: Error {
    case fault(String)
  }

  let ref: OpaquePointer
  static let bufsize = 256

  static func errMsg(_ ofCode: Int32) -> String? {
    let buf = UnsafeMutablePointer<UInt8>.allocate(capacity: PCRE2.bufsize)
    defer {
      #if swift ( >=4.1 )
        buf.deallocate()
      #else
        buf.deallocate(capacity: PCRE2.bufsize)
      #endif
    }
    buf.initialize(to: 0)
    let size = pcre2_get_error_message_8(ofCode, buf, PCRE2.bufsize)
    guard size > 0 else { return nil }
    let array = UnsafeBufferPointer<UInt8>(start: buf, count: Int(size))
    return String(bytes: Array(array), encoding: .utf8)
  }

  static func errMsg(_ ofCode: Int32, offset: Int) -> String {
    let msg: String
    if let message = PCRE2.errMsg(ofCode) {
      msg = message
    } else {
      msg = "unknown"
    }
    return "fault offset #\(offset): " + msg
  }

  /// initialize a regular expression instance by the pattern and option
  /// - parameter pattern: pattern string
  /// - parameter options: options to pass
  /// - throws: Exception
  public init(pattern: String, options: [OptionPattern] = [.UTF]) throws {
    var errCode: Int32 = 0
    var errOffset = 0
    let op = options.map { $0.rawValue }.reduce(0) { $0 | $1 }

    guard let re = pcre2_compile_8(pattern, pattern.count, op, &errCode, &errOffset, nil) else {
      throw Exception.fault("PCRE2 compilation " + PCRE2.errMsg(errCode, offset: errOffset))
    }
    ref = re
  }

  deinit {
    pcre2_code_free_8(ref)
  }

  /// scan a string (with allowing multiple lines) for matches
  /// each match is an array of ranges
  /// and the first range of the array is the full match ($0)
  /// and the rest of the ranges are the captured groups ($1, $2, etc)
  /// ```
  /// let http = try PCRE2(pattern: "([A-Z]+)/([0-9.]+)\\s+([0-9]+)\\s+(.*)")
  /// let source = """
  /// HTTP/1.1 100 continue
  /// HTTP/1.0 200 OK
  /// """
  /// let lines = try http.match(source)
  /// lines.forEach { line in
  /// print("================")
  /// print("full: $0", source[line[0]])
  /// print("head: $1", source[line[1]])
  /// print("vers: $2", source[line[2]])
  /// print("code: $3", source[line[3]])
  /// print("stat: $4", source[line[4]])
  /// }
  /// ```
  /// - parameter subject: the subject string to scan
  /// - parameter options: the options to apply in the match
  /// - returns: array of matched ranges of the subject
  /// - throws: Exception
  public func match(_ subject: String, options: [OptionMatch] = []) throws -> [[Range<String.Index>]] {

    guard let matchData = pcre2_match_data_create_from_pattern_8(ref, nil) else {
      throw Exception.fault("unable to allocate memory for matching")
    }
    defer {
      pcre2_match_data_free_8(matchData)
    }
    var ranges: [[Range<String.Index>]] = []
    let op = options.map { $0.rawValue }.reduce(0) { $0 | $1 }
    var offset = 0
    repeat {
      var range: [Range<String.Index>] = []
      let rc = pcre2_match_8(ref, subject, subject.count, offset, op, matchData, nil)
      if rc == PCRE2_ERROR_NOMATCH { break }
      if rc == 0 { throw Exception.fault("insufficient size of match data for all captured substrings")}
      guard rc > 0,
        let ovector = pcre2_get_ovector_pointer_8(matchData) else {
          throw Exception.fault(PCRE2.errMsg(rc, offset: offset))
      }
      let array = Array(UnsafeBufferPointer<Int>(start: ovector, count: Int(rc) * 2))
      for i in 0..<Int(rc) {
        let start = String.Index(utf16Offset: array[i * 2], in: subject)
        let end = String.Index(utf16Offset: array[i * 2 + 1], in: subject)
        offset = array[i * 2 + 1] + 1
        range.append(start..<end)
      }
      ranges.append(range)
    } while offset < subject.count
    return ranges
  }
}

public extension String {
  /// scan a string (with allowing multiple lines) for matches
  /// each match is an array of strings
  /// and the first string of the array is the full match ($0)
  /// and the rest of the sub strings are the captured groups ($1, $2, etc)
  /// ```
  /// let lines = try "HTTP/1.1 100 continue\r\nHTTP/1.0 200 OK\r\n"
  ///   .pcre2Match(pattern: "([a-zA-Z]+)/([0-9.]+)\\s+([0-9]+)\\s+(.*)")
  /// lines.forEach { line in
  ///   print("head: $1", line[1]) // HTTP
  ///   print("vers: $2", line[2]) // 1.0 or 1.1
  ///   print("code: $3", line[3]) // 100 or 200
  ///   print("stat: $4", line[4]) // continue or OK
  /// }
  /// ```
  /// - parameter pattern: the regular expression to apply
  /// - parameter optionsOfPattern: the options to apply in the pattern creation
  /// - parameter optionsOfMatch: the options to apply in the pattern match
  /// - returns: array of matched substrings
  /// - throws: Exception
  func pcre2Match(pattern: String, optionsOfPattern: [PCRE2.OptionPattern] = [.UTF], optionsOfMatch: [PCRE2.OptionMatch] = []) throws -> [[String]] {
    let re = try PCRE2(pattern: pattern, options: optionsOfPattern)
    let ranges = try re.match(self, options: optionsOfMatch)
    return ranges.map { $0.map { String(self[$0]) } }
  }
}
