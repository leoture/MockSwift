//MockDefaultTests.swift
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

import XCTest
import MockSwift

private struct CustomReturnType: Equatable {
  let identifier: String
}

private protocol Custom {
  func function() -> CustomReturnType
  func functionVoid()
  func functionBool() -> Bool
  func functionInt() -> Int
  func functionString() -> String
}

extension CustomReturnType: MockDefault {
  static func `default`() -> CustomReturnType {
    CustomReturnType(identifier: "default")
  }
}

extension Mock: Custom where WrappedType == Custom {
  func function() -> CustomReturnType { mocked() }
  func functionVoid() { mocked() }
  func functionBool() -> Bool { mocked() }
  func functionInt() -> Int { mocked() }
  func functionString() -> String { mocked() }
}

class MockDefaultTests: XCTestCase {
  @Mock private var custom: Custom

  func test_function_shouldReturnDefaultCustom() {
    XCTAssertEqual(custom.function(), CustomReturnType.default())
  }

  func test_functionVoid_shouldReturnVoid() {
    XCTAssertNotNil(custom.functionVoid())
  }

  func test_functionBool_shouldReturnDefaultBool() {
    XCTAssertEqual(custom.functionBool(), Bool.default())
  }

  func test_functionInt_shouldReturnDefaultInt() {
    XCTAssertEqual(custom.functionInt(), Int.default())
  }

  func test_functionString_shouldReturnDefaultString() {
    XCTAssertEqual(custom.functionString(), String.default())
  }

  static var allTests = [
    ("test_function_shouldReturnDefaultCustom",
     test_function_shouldReturnDefaultCustom),

    ("test_functionVoid_shouldReturnVoid",
     test_functionVoid_shouldReturnVoid),

    ("test_functionBool_shouldReturnDefaultBool",
     test_functionBool_shouldReturnDefaultBool),

    ("test_functionInt_shouldReturnDefaultInt",
     test_functionInt_shouldReturnDefaultInt),

    ("test_functionString_shouldReturnDefaultString",
     test_functionString_shouldReturnDefaultString)
  ]
}
