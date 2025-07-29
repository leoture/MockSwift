// XCTestFailureRecorder.swift
/*
 MIT License

 Copyright (c) 2019 Jordhan Leoture

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

#if canImport(XCTest)

import XCTest

class XCTestFailureRecorder: FailureRecorder {
  func recordFailure(message: String, file: StaticString, line: UInt) {
    XCTFail(message, file: file, line: line)
  }
}
#endif

#if canImport(Testing)

import Testing

class SwiftTestingFailureRecorder: FailureRecorder {
  func recordFailure(message: String, file: StaticString, line: UInt) {
    Issue.record(
      Comment(rawValue: message),
      sourceLocation: Testing.SourceLocation(
        fileID: #fileID, // TODO: pass #fileID from then()
        filePath: file.withUTF8Buffer { String(decoding: $0, as: UTF8.self) },
        line: Int(line),
        column: 1 // TODO: pass #column from then()
      )
    )
  }
}
#endif

class TestingFailureRecorder: FailureRecorder {
  func recordFailure(message: String, file: StaticString, line: UInt) {
#if canImport(XCTest)
    XCTestFailureRecorder().recordFailure(message: message, file: file, line: line)
#endif
#if canImport(Testing)
    SwiftTestingFailureRecorder().recordFailure(message: message, file: file, line: line)
#endif
  }
}
