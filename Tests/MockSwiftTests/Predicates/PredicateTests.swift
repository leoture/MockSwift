//PredicateTests.swift
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

class PredicateTests: XCTestCase {

  func test_satisfy_withMatchShouldReturnFalseIfInputIsNotTheSameType() {
    let predicate: Predicate<String> = .match { _ in
      true
    }
    XCTAssertFalse(predicate.satisfy(by: 1))
  }

  func test_satisfy_shouldReturnFalseIfInputNotMatched() {
    let predicate: Predicate<String> = .match { value in
      value.isEmpty
    }

    XCTAssertFalse(predicate.satisfy(by: "not Empty"))
  }

  func test_satisfy_shouldReturnTrueIfInputMatched() {
    let predicate: Predicate<String> = .match { value in
      value.isEmpty
    }

    XCTAssertTrue(predicate.satisfy(by: ""))
  }

  func test_satisfy_withAnyshouldReturnFalseIfInputIsNotTheSameType() {
    let predicate: Predicate<String> = .any
    XCTAssertFalse(predicate.satisfy(by: 1))
  }

  func test_satisfy_shouldReturnTrue() {
    let predicate: Predicate<String> = .any
    XCTAssertTrue(predicate.satisfy(by: ""))
  }

  func test_description_withMatch() {
    let predicate: Predicate<String> = .match(description: "description") { _ in
      true
    }
    XCTAssertEqual("\(predicate)", "description")
  }

  func test_description_withAny() {
    let predicate: Predicate<String> = .any

    XCTAssertEqual("\(predicate)", "any")
  }

  static var allTests = [
    ("test_satisfy_withMatchShouldReturnFalseIfInputIsNotTheSameType",
     test_satisfy_withMatchShouldReturnFalseIfInputIsNotTheSameType),

    ("test_satisfy_shouldReturnFalseIfInputNotMatched",
     test_satisfy_shouldReturnFalseIfInputNotMatched),

    ("test_satisfy_shouldReturnTrueIfInputMatched",
     test_satisfy_shouldReturnTrueIfInputMatched),

    ("test_satisfy_withAnyshouldReturnFalseIfInputIsNotTheSameType",
     test_satisfy_withAnyshouldReturnFalseIfInputIsNotTheSameType),

    ("test_satisfy_shouldReturnTrue",
     test_satisfy_shouldReturnTrue),

    ("test_description_withMatch",
     test_description_withMatch),

    ("test_description_withAny",
     test_description_withAny)
  ]
}
