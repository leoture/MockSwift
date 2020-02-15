//AnyPredicateEquatableTests.swift
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

private class Custom: NSObject {
  var equalsReceived: (lhs: Custom, rhs: Custom)?
  var equalsReturn: Bool!

  override func isEqual(_ object: Any?) -> Bool {
    if let object = object as? Custom {
      equalsReceived = (self, object)
    }
    return equalsReturn
  }
}

class AnyPredicateEquatableTests: XCTestCase {

  func test_satisfy_shouldReturnTrueIfEquals() {
    // Given
    let lhsCustom = Custom()
    let rhsCustom = Custom()
    lhsCustom.equalsReturn = true

    // When
    let result = lhsCustom.satisfy(by: rhsCustom)

    //Then
    XCTAssertTrue(result)
    let argument = lhsCustom.equalsReceived
    XCTAssertTrue(argument?.lhs === lhsCustom)
    XCTAssertTrue(argument?.rhs === rhsCustom)
  }

  func test_satisfy_shouldReturnFalseIfNotEquals() {
    // Given
    let lhsCustom = Custom()
    let rhsCustom = Custom()
    lhsCustom.equalsReturn = false

    // When
    let result = lhsCustom.satisfy(by: rhsCustom)

    //Then
    XCTAssertFalse(result)
    let argument = lhsCustom.equalsReceived
    XCTAssertTrue(argument?.lhs === lhsCustom)
    XCTAssertTrue(argument?.rhs === rhsCustom)
  }

  func test_satify_shouldReturnTrueWithArray() {
    // Given
    let lhsCustom = Custom()
    let rhsCustom = Custom()
    lhsCustom.equalsReturn = true

    // When
    let result = [lhsCustom].satisfy(by: [rhsCustom])

    //Then
    XCTAssertTrue(result)
  }

  func test_satify_shouldReturnFalseWithArray() {
    // Given
    let lhsCustom = Custom()
    let rhsCustom = Custom()
    lhsCustom.equalsReturn = false

    // When
    let result = [lhsCustom].satisfy(by: [rhsCustom])

    //Then
    XCTAssertFalse(result)
  }

  func test_satify_shouldReturnTrueWithBool() { XCTAssertTrue(false.satisfy(by: false)) }
  func test_satify_shouldReturnFalseWithBool() { XCTAssertFalse(false.satisfy(by: true)) }

  func test_satify_shoudReturnTrueWithInt() { XCTAssertTrue(0.satisfy(by: 0)) }
  func test_satify_shoudReturnFalseWithInt() { XCTAssertFalse(0.satisfy(by: 1)) }

  func test_satify_shouldReturnTrueWithString() { XCTAssertTrue("value".satisfy(by: "value")) }
  func test_satify_shouldReturnFalseWithString() { XCTAssertFalse("value".satisfy(by: "")) }

  func test_satify_shouldReturnTrueWithFloat() { XCTAssertTrue(2.0.satisfy(by: 2.0)) }
  func test_satify_shouldReturnFalseWithFloat() { XCTAssertFalse(2.0.satisfy(by: 2.3)) }
}
