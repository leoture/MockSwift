//PredicateBoolTests.swift
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

class PredicatBoolTests: XCTestCase {

  func test_isTrue_shouldReturnTrue() {
    let predicate: Predicate<Bool> = .isTrue
    XCTAssertTrue(predicate.satisfy(by: true))
  }

  func test_isTrue_shouldReturnFalse() {
    let predicate: Predicate<Bool> = .isTrue
    XCTAssertFalse(predicate.satisfy(by: false))
  }

  func test_isTrue_description() {
    let predicate: Predicate<Bool> = .isTrue
    XCTAssertEqual(predicate.description, "True")
  }

  func test_isFalse_shouldReturnTrue() {
    let predicate: Predicate<Bool> = .isFalse
    XCTAssertTrue(predicate.satisfy(by: false))
  }

  func test_isFalse_shouldReturnFalse() {
    let predicate: Predicate<Bool> = .isFalse
    XCTAssertFalse(predicate.satisfy(by: true))
  }

  func test_isFalse_description() {
    let predicate: Predicate<Bool> = .isFalse
    XCTAssertEqual(predicate.description, "False")
  }
}
