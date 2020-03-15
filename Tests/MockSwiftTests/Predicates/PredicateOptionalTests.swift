// PredicateOptionalTests.swift
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

import Foundation
import MockSwift
import XCTest

class PredicateOptionalTests: XCTestCase {
  func test_isNil_shouldReturnTrue() {
    let predicate: Predicate<Int?> = .isNil()
    XCTAssertTrue(predicate.satisfy(by: nil))
  }

  func test_isNil_shouldReturnFalse() {
    let predicate: Predicate<Int?> = .isNil()
    XCTAssertFalse(predicate.satisfy(by: 0))
  }

  func test_isNil_description() {
    let predicate: Predicate<Int?> = .isNil()
    XCTAssertEqual(predicate.description, "nil")
  }
}
