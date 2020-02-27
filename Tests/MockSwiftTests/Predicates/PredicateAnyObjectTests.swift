//PredicateAnyObjectTests.swift
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

private class Custom {
}

class PredicateAnyObjectTests: XCTestCase {

  // MARK: - Operator

  func test_operator_identicalTo_shouldReturnFalse() {
    // Given
    let custom = Custom()
    let customCompared = Custom()

    // When
    let result = (===customCompared).satisfy(by: custom)

    //Then
    XCTAssertFalse(result)
  }

  func test_operator_identicalTo_shouldReturnTrue() {
    // Given
    let custom = Custom()
    let customCompared = custom

    // When
    let result = (===customCompared).satisfy(by: custom)

    //Then
    XCTAssertTrue(result)
  }

  func test_operator_identicalTo_description() {
    // Given
    let customCompared = Custom()
    let reference = "\(Unmanaged.passUnretained(customCompared).toOpaque())"

    // When
    let description = (===customCompared).description

    //Then
    XCTAssertEqual(description, reference)
  }

  // MARK: - identicalTo

  func test_identicalTo_shouldReturnFalse() {
    // Given
    let custom = Custom()
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.identical(to: customCompared).satisfy(by: custom)

    //Then
    XCTAssertFalse(result)
  }

  func test_identicalTo_shouldReturnTrue() {
    // Given
    let custom = Custom()
    let customCompared = custom

    // When
    let result = Predicate<Custom>.identical(to: customCompared).satisfy(by: custom)

    //Then
    XCTAssertTrue(result)
  }

  func test_identicalTo_description() {
    // Given
    let customCompared = Custom()
    let reference = "\(Unmanaged.passUnretained(customCompared).toOpaque())"

    // When
    let description = Predicate<Custom>.identical(to: customCompared).description

    //Then
    XCTAssertEqual(description, reference)
  }

  // MARK: - id

  func test_id_shouldReturnFalse() {
    // Given
    let custom = Custom()
    let customCompared = Custom()

    // When
    let result = Predicate<Custom>.id(customCompared).satisfy(by: custom)

    //Then
    XCTAssertFalse(result)
  }

  func test_id_shouldReturnTrue() {
    // Given
    let custom = Custom()
    let customCompared = custom

    // When
    let result = Predicate<Custom>.id(customCompared).satisfy(by: custom)

    //Then
    XCTAssertTrue(result)
  }

  func test_id_description() {
    // Given
    let customCompared = Custom()
    let reference = "\(Unmanaged.passUnretained(customCompared).toOpaque())"

    // When
    let description = Predicate<Custom>.id(customCompared).description

    //Then
    XCTAssertEqual(description, reference)
  }

}
