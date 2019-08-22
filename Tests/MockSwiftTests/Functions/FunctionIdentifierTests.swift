//FunctionIdentifierTests.swift
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
@testable import MockSwift

class FunctionIdentifierTests: XCTestCase {

  func test_callDescription_withNoParameters() {
    let description = FunctionIdentifier(function: "f()", return: Int.self).callDescription(with: [])
    XCTAssertEqual(description, "f() -> Int")
  }

  func test_callDescription_withParameters() {
    let description = FunctionIdentifier(function: "f(arg1:arg2:)", return: Int.self)
      .callDescription(with: ["description1", 2])
    XCTAssertEqual(description, "f(arg1: description1, arg2: 2) -> Int")
  }

  static var allTests = [
    ("test_callDescription_withNoParameters",
     test_callDescription_withNoParameters),

    ("test_callDescription_withParameters",
     test_callDescription_withParameters)
  ]
}
