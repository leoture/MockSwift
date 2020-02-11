//BasicSubscriptsTests.swift
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
@testable import MockSwiftExample

class BasicSubscriptTests: XCTestCase {
  @Mock private var basicSubscript: BasicSubscript

  func test_subscript_withPredicates() {
    // Given
    var parameters: [Any]?
    given(basicSubscript) {
      $0[.match(when: \.isEmpty), .equalsTo(rhs: 1)].get.willReturn(true)
      $0[.any(), .any()].set(.isFalse()).will { parameters = $0 }
    }

    // When
    let result = basicSubscript["", 1]
    basicSubscript["hello", 2] = false

    //Then
    XCTAssertTrue(result)
    XCTAssertEqual(parameters?[0] as? String, "hello")
    XCTAssertEqual(parameters?[1] as? Int, 2)
    XCTAssertEqual(parameters?[2] as? Bool, false)
    then(basicSubscript) {
      $0[.equalsTo(rhs: ""), .equalsTo(rhs: 1)].get.called()
      $0[.equalsTo(rhs: "hello"), .moreThan(rhs: 0)].set(.isFalse()).called()
    }
  }

  func test_subscript_withTypes() {
    // Given
    var parameters: [Any]?
    given(basicSubscript) {
      $0["", 1].get.willReturn(true)
      $0["hello", 2].set(false).will { parameters = $0 }
    }

    // When
    let result = basicSubscript["", 1]
    basicSubscript["hello", 2] = false

    //Then
    XCTAssertTrue(result)
    XCTAssertEqual(parameters?[0] as? String, "hello")
    XCTAssertEqual(parameters?[1] as? Int, 2)
    XCTAssertEqual(parameters?[2] as? Bool, false)
    then(basicSubscript) {
      $0["", 1].get.called()
      $0["hello", 2].set(false).called()
    }
  }

  func test_subscriptWithLabels_withPredicates() {
    // Given
    given(basicSubscript) {
      $0[with: .match(when: \.isEmpty), and: .equalsTo(rhs: 1)].get.willReturn("value")
    }

    // When
    let result = basicSubscript[with: "", and: 1]

    //Then
    XCTAssertEqual(result, "value")
    then(basicSubscript) {
      $0[with: .equalsTo(rhs: ""), and: .equalsTo(rhs: 1)].get.called()
    }
  }

  func test_subscriptWithLabels_withTypes() {
    // Given
    given(basicSubscript) {
      $0[with: "", and: 1].get.willReturn("value")
    }

    // When
    let result = basicSubscript[with: "", and: 1]

    //Then
    XCTAssertEqual(result, "value")
    then(basicSubscript) {
      $0[with: "", and: 1].get.called()
    }
  }
}

