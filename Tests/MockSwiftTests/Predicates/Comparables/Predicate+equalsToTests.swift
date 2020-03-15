// Predicate+equalsToTests.swift
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
import XCTest

private class Custom: Equatable, CustomStringConvertible {
  var comparisonReceived: Custom?
  var comparisonReturn: Bool!
  var description: String = ""

  static func == (lhs: Custom, rhs: Custom) -> Bool {
    lhs.comparisonReceived = rhs
    return lhs.comparisonReturn
  }
}

class PredicateEqualsToTests: XCTestCase {
  // MARK: - Operator

  func test_operator_equalsTo_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = (==customCompared).satisfy(by: custom)

    // Then
    XCTAssertFalse(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_operator_equalsTo_shouldReturnTrueIfComparisonReturnTrue() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = true
    let customCompared = Custom()

    // When
    let result = (==customCompared).satisfy(by: custom)

    // Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_operator_equalsTo_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = (==customCompared).description

    // Then
    XCTAssertEqual(description, "description")
  }

  // MARK: - equalsTo

  func test_equalsTo_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.equals(to: customCompared).satisfy(by: custom)

    // Then
    XCTAssertFalse(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_equalsTo_shouldReturnTrueIfComparisonReturnTrue() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = true
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.equals(to: customCompared).satisfy(by: custom)

    // Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_equalsTo_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = Predicate<Custom>.equals(to: customCompared).description

    // Then
    XCTAssertEqual(description, "description")
  }

  // MARK: - eq

  func test_eq_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.eq(customCompared).satisfy(by: custom)

    // Then
    XCTAssertFalse(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_eq_shouldReturnTrueIfComparisonReturnTrue() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = true
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.eq(customCompared).satisfy(by: custom)

    // Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_eq_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = Predicate<Custom>.eq(customCompared).description

    // Then
    XCTAssertEqual(description, "description")
  }
}
