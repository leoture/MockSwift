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
@testable import MockSwift

private class Custom {}

class PredicateTests: XCTestCase {

  // MARK: - match(description:any type:_ predicate:)

  func test_match_withMatchShouldReturnFalseIfInputIsNotTheSameType() {
    func assertion<T>(_ predicate: Predicate<T>) {
      XCTAssertFalse(predicate.satisfy(by: 1))
    }

    assertion(.match(any: String.self) { _ in true })
  }

  func test_match_shouldReturnFalseIfInputNotMatched() {
    func assertion<T>(_ predicate: Predicate<T>) {
      XCTAssertFalse(predicate.satisfy(by: "not Empty"))
    }

    assertion(.match(any: String.self) {$0.isEmpty})
  }

  func test_match_shouldReturnTrueIfInputMatched() {
    func assertion<T>(_ predicate: Predicate<T>) {
      XCTAssertTrue(predicate.satisfy(by: ""))
    }

    assertion(.match(any: String.self) {$0.isEmpty})
  }

  func test_match_description() {
    let predicate: Predicate<String> = .match { _ in
      true
    }
    XCTAssertEqual("\(predicate)", "a String")
  }

  // MARK: - match(_ value:file:line:)

  func test_match_shouldReturnTrueIfInputMatchedByAnyPredicate() {
    let anyPredicate: AnyPredicate = Predicate<String>.match { value in
      value.isEmpty
    }
    let predicate: AnyPredicate = Predicate<AnyPredicate>.match(anyPredicate)

    XCTAssertTrue(predicate.satisfy(by: ""))
  }

  func test_match_shouldReturnFalseIfInputNotMatchedByAnyPredicate() {
    let anyPredicate: AnyPredicate = Predicate<String>.match { value in
      value.isEmpty
    }
    let predicate: AnyPredicate = Predicate<AnyPredicate>.match(anyPredicate)

    XCTAssertFalse(predicate.satisfy(by: "not Empty"))
  }

  func test_match_shouldReturnTrueIfInputSameReference() {
    let custom = Custom()
    let predicate: AnyPredicate = Predicate<Custom>.match(custom)

    XCTAssertTrue(predicate.satisfy(by: custom))
  }

  func test_match_shouldReturnFalseIfInputNotSameReference() {
    let custom = Custom()
    let predicate: AnyPredicate = Predicate<Custom>.match(custom)

    XCTAssertFalse(predicate.satisfy(by: Custom()))
  }

  // MARK: - match(description:any type:when keyPath:)

  func test_match_shouldReturnTrueIfKeyPathReturnTrue() {
    func assertion<T>(_ predicate: Predicate<T>) {
      XCTAssertTrue(predicate.satisfy(by: ""))
    }

    assertion(.match(any: String.self, when: \.isEmpty))
  }

  func test_match_shouldReturnFalseIfKeyPathReturnFalse() {
    func assertion<T>(_ predicate: Predicate<T>) {
      XCTAssertFalse(predicate.satisfy(by: "not Empty"))
    }

    assertion(.match(any: String.self, when: \.isEmpty))
  }

  func test_match_KeyPathDescription() {
    let predicate: Predicate<String> = .match(when: \.isEmpty)

    XCTAssertEqual("\(predicate)", "a String")
  }

  // MARK: - any(_ type:)

  func test_any_shouldReturnFalse() {
    func assertion<T>(_ predicate: Predicate<T>) {
      XCTAssertFalse(predicate.satisfy(by: 1))
    }

    assertion(.any(String.self))
  }

  func test_any_shouldReturnTrue() {
    func assertion<T>(_ predicate: Predicate<T>) {
      XCTAssertTrue(predicate.satisfy(by: ""))
    }

    assertion(.any(String.self))
  }

  func test_any_description() {
    let predicate: Predicate<String> = .any()

    XCTAssertEqual("\(predicate)", "any String")
  }

  func test_not_shouldReturnFalse() {
    let predicate: Predicate<String> = .not(.match { _ in true })
    XCTAssertFalse(predicate.satisfy(by: ""))
  }

  func test_not_shouldReturnTrue() {
    let predicate: Predicate<String> = .not(.match { _ in false })
    XCTAssertTrue(predicate.satisfy(by: ""))
  }

  func test_not_description() {
    let predicate: Predicate<String> = .not(.match(description: "description") { _ in true })
    XCTAssertEqual("\(predicate)", "not description")
  }
}
