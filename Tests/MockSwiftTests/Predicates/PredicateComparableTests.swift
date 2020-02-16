//PredicateComparableTests.swift
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

private class Custom: Comparable, CustomStringConvertible {
  var comparisonReceived: Custom?
  var comparisonReturn: Bool!
  var description: String = ""

  static func < (lhs: Custom, rhs: Custom) -> Bool {
    lhs.comparisonReceived = rhs
    return lhs.comparisonReturn
  }

  static func <= (lhs: Custom, rhs: Custom) -> Bool {
    lhs.comparisonReceived = rhs
    return lhs.comparisonReturn
  }

  static func > (lhs: Custom, rhs: Custom) -> Bool {
    lhs.comparisonReceived = rhs
    return lhs.comparisonReturn
  }

  static func >= (lhs: Custom, rhs: Custom) -> Bool {
    lhs.comparisonReceived = rhs
    return lhs.comparisonReturn
  }

  static func == (lhs: Custom, rhs: Custom) -> Bool {
    lhs.comparisonReceived = rhs
    return lhs.comparisonReturn
  }
}

class PredicateComparableTests: XCTestCase {

  // MARK: - EqualsTo
  func test_operator_equalsTo_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = (==customCompared).satisfy(by: custom)

    //Then
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

    //Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_operator_equalsTo_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = (==customCompared).description

    //Then
    XCTAssertEqual(description, "description")
  }

  func test_equalsTo_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.equals(to: customCompared).satisfy(by: custom)

    //Then
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

    //Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_equalsTo_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = Predicate<Custom>.equals(to: customCompared).description

    //Then
    XCTAssertEqual(description, "description")
  }

  // MARK: - GreaterThan

  func test_operator_greaterThan_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = (>customCompared).satisfy(by: custom)

    //Then
    XCTAssertFalse(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_operator_greaterThan_shouldReturnTrueIfComparisonReturnTrue() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = true
    let customCompared = Custom()

    // When
    let result = (>customCompared).satisfy(by: custom)

    //Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_operator_greaterThan_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = (>customCompared).description

    //Then
    XCTAssertEqual(description, "greater than description")
  }

  func test_greaterThan_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = (Predicate<Custom>.greater(than: customCompared)).satisfy(by: custom)

    //Then
    XCTAssertFalse(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_greaterThan_shouldReturnTrueIfComparisonReturnTrue() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = true
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.greater(than: customCompared).satisfy(by: custom)

    //Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_greaterThan_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = (Predicate<Custom>.greater(than: customCompared)).description

    //Then
    XCTAssertEqual(description, "greater than description")
  }

  // MARK: - GreaterThanOrEqualsTo

  func test_operator_greaterThanOrEqualsTo_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = (>=customCompared).satisfy(by: custom)

    //Then
    XCTAssertFalse(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_operator_greaterThanOrEqualsTo_shouldReturnTrueIfComparisonReturnTrue() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = true
    let customCompared = Custom()

    // When
    let result = (>=customCompared).satisfy(by: custom)

    //Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_operator_greaterThanOrEqualsTo_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = (>=customCompared).description

    //Then
    XCTAssertEqual(description, "greater than or equals to description")
  }

  func test_greaterThanOrEqualsTo_shouldReturnFalseIfComparisonReturnFalse() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = false
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.greaterThanOrEquals(to: customCompared).satisfy(by: custom)

    //Then
    XCTAssertFalse(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_greaterThanOrEqualsTo_shouldReturnTrueIfComparisonReturnTrue() {
    // Given
    let custom = Custom()
    custom.comparisonReturn = true
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.greaterThanOrEquals(to: customCompared).satisfy(by: custom)

    //Then
    XCTAssertTrue(result)
    XCTAssertTrue(custom.comparisonReceived === customCompared)
  }

  func test_greaterThanOrEqualsTo_description() {
    // Given
    let customCompared = Custom()
    customCompared.description = "description"

    // When
    let description = Predicate<Custom>.greaterThanOrEquals(to: customCompared).description

    //Then
    XCTAssertEqual(description, "greater than or equals to description")
  }

  // MARK: - LessThan

  func test_lessThan_shouldReturnFalseIfComparisonReturnFalse() {
     // Given
     let custom = Custom()
     custom.comparisonReturn = false
     let customCompared = Custom()

     // When
    let result = Predicate<Custom>.less(than: customCompared).satisfy(by: custom)

     //Then
     XCTAssertFalse(result)
     XCTAssertTrue(custom.comparisonReceived === customCompared)
   }

   func test_lessThan_shouldReturnTrueIfComparisonReturnTrue() {
     // Given
     let custom = Custom()
     custom.comparisonReturn = true
     let customCompared = Custom()

     // When
     let result = Predicate<Custom>.less(than: customCompared).satisfy(by: custom)

     //Then
     XCTAssertTrue(result)
     XCTAssertTrue(custom.comparisonReceived === customCompared)
   }

   func test_lessThan_description() {
     // Given
     let customCompared = Custom()
     customCompared.description = "description"

     // When
     let description = Predicate<Custom>.less(than: customCompared).description

     //Then
     XCTAssertEqual(description, "less than description")
   }

  // MARK: - LessThanOrEqualsTo

  func test_lessThanOrEqualsTo_shouldReturnFalseIfComparisonReturnFalse() {
     // Given
     let custom = Custom()
     custom.comparisonReturn = false
     let customCompared = Custom()

     // When
     let result = Predicate<Custom>.lessThanOrEquals(to: customCompared).satisfy(by: custom)

     //Then
     XCTAssertFalse(result)
     XCTAssertTrue(custom.comparisonReceived === customCompared)
   }

   func test_lessThanOrEqualsTo_shouldReturnTrueIfComparisonReturnTrue() {
     // Given
     let custom = Custom()
     custom.comparisonReturn = true
     let customCompared = Custom()

     // When
     let result = Predicate<Custom>.lessThanOrEquals(to: customCompared).satisfy(by: custom)

     //Then
     XCTAssertTrue(result)
     XCTAssertTrue(custom.comparisonReceived === customCompared)
   }

   func test_lessThanOrEqualsTo_description() {
     // Given
     let customCompared = Custom()
     customCompared.description = "description"

     // When
    let description = Predicate<Custom>.lessThanOrEquals(to: customCompared).description

     //Then
     XCTAssertEqual(description, "less than or equals to description")
   }
}
