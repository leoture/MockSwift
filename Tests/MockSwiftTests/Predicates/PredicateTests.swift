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

private class Custom {}

class PredicateTests: XCTestCase {

  func test_match_withMatchShouldReturnFalseIfInputIsNotTheSameType() {
    let predicate: Predicate<String> = .match { _ in
      true
    }
    XCTAssertFalse(predicate.satisfy(by: 1))
  }

  func test_match_shouldReturnFalseIfInputNotMatched() {
    let predicate: Predicate<String> = .match { value in
      value.isEmpty
    }

    XCTAssertFalse(predicate.satisfy(by: "not Empty"))
  }

  func test_match_shouldReturnTrueIfInputMatched() {
    let predicate: Predicate<String> = .match { value in
      value.isEmpty
    }

    XCTAssertTrue(predicate.satisfy(by: ""))
  }

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

  func test_match_description() {
    let predicate: Predicate<String> = .match(description: "description") { _ in
      true
    }
    XCTAssertEqual("\(predicate)", "description")
  }

  func test_match_shouldReturnTrueIfKeyPathReturnTrue() {
    let predicate: AnyPredicate = Predicate<String>.match(\.isEmpty)

     XCTAssertTrue(predicate.satisfy(by: ""))
   }

   func test_match_shouldReturnFalseIfKeyPathReturnFalse() {
     let predicate: AnyPredicate = Predicate<String>.match(\.isEmpty)

     XCTAssertFalse(predicate.satisfy(by: "not Empty"))
   }

   func test_match_KeyPathDescription() {
     let predicate: AnyPredicate = Predicate<String>.match(description: "description", \.isEmpty)

     XCTAssertEqual("\(predicate)", "description")
   }

  func test_any_shouldReturnFalse() {
    let predicate: Predicate<String> = .any()
    XCTAssertFalse(predicate.satisfy(by: 1))
  }

  func test_any_shouldReturnTrue() {
    let predicate: Predicate<String> = .any()
    XCTAssertTrue(predicate.satisfy(by: ""))
  }

  func test_any_description() {
    let predicate: Predicate<String> = .any()

    XCTAssertEqual("\(predicate)", "any")
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
