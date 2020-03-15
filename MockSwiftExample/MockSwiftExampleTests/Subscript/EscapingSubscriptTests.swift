// EscapingSubscriptTests.swift
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

import MockSwift
@testable import MockSwiftExample
import XCTest

class EscapingSubscriptTests: XCTestCase {
  @Mock private var escapingSubscript: EscapingSubscript

  func test_subscript_withPredicates() {
    // Given
    var parameters: [Any]?
    given(escapingSubscript) {
      $0[.match { $0("") }].get.willReturn(true)
      $0[.any()].set(.isTrue()).will { parameters = $0 }
    }

    // When
    let result = escapingSubscript[{ $0.isEmpty }]
    escapingSubscript[{ $0 == "value" }] = true

    // Then
    XCTAssertTrue(result)
    let block = parameters?[0] as? (String) -> Bool
    XCTAssertEqual(block?("value"), true)
    XCTAssertEqual(parameters?[1] as? Bool, true)
    then(escapingSubscript) {
      $0[.any()].get.called()
      $0[.any()].set(.isTrue()).called()
    }
  }

  func test_subscript_withTypes() {
    // block cannot be used as predicate.
    // Given
    var parameters: [Any]?
    let getBlock: (String) -> Bool = { $0.isEmpty }
    let setBlock: (String) -> Bool = { $0 == "value" }

    given(escapingSubscript) {
      $0[getBlock].get.willReturn(true)
      $0[setBlock].set(true).will { parameters = $0 }
    }

    // When
    let result = escapingSubscript[getBlock]
    escapingSubscript[setBlock] = true

    // Then
    XCTAssertFalse(result)
    XCTAssertNil(parameters)
    then(escapingSubscript) {
      $0[getBlock].get.called(times: 0)
      $0[setBlock].set(true).called(times: 0)
    }
  }
}
