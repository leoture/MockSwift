//MockableSubscriptWritableTests.swift
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
import XCTest
@testable import MockSwift

final class MockableSubscriptWritableTests: XCTestCase {

  private let builder = MockableBuilderMock()
  private let expectedFunction = "subscript(_:)"
  private let expectedLine: UInt = 1
  private let expectedPredicates = [1, 2]
  private var writable: MockableSubscript.Writable<Bool>!

  override func setUp() {
    writable = MockableSubscript.Writable<Bool>(function: expectedFunction,
                                               file: "file",
                                               line: expectedLine,
                                               mockableBuilder: builder,
                                               predicates: expectedPredicates)
  }

  func test_get_shouldCorrectlyCallBuilder() {
    // Given
    let expectedMockable = Mockable<Bool>.stub()
    builder.mockablePredicatesReturn = expectedMockable

    // When
    _  = writable.get

    // Then
    XCTAssertEqual(builder.mockablePredicatesReceived.count, 1)
    let (predicates, function, file, line) = builder.mockablePredicatesReceived[0]
    XCTAssertEqual(predicates as? [Int], expectedPredicates)
    XCTAssertEqual(function, expectedFunction)
    XCTAssertEqual(file, "file")
    XCTAssertEqual(line, expectedLine)
  }

  func test_get_shouldReturnValueFromBuilder() {
    // Given
    let expectedMockable = Mockable<Bool>.stub()
    builder.mockablePredicatesReturn = expectedMockable

    // When
    let mockable = writable.get

    // Then
    XCTAssertTrue(mockable === expectedMockable)
  }

  func test_set_shouldCorrectlyCallBuilder() {
    // Given
    let expectedMockable = Mockable<Void>.stub()
    builder.mockablePredicatesReturn = expectedMockable

    // When
    _  = writable.set(true)

    // Then
    XCTAssertEqual(builder.mockablePredicatesReceived.count, 1)
    let (predicates, function, file, line) = builder.mockablePredicatesReceived[0]
    XCTAssertEqual(predicates.count, 3)
    XCTAssertEqual(predicates[0] as? Int, 1)
    XCTAssertEqual(predicates[1] as? Int, 2)
    XCTAssertEqual(predicates[2] as? Bool, true)
    XCTAssertEqual(function, expectedFunction)
    XCTAssertEqual(file, "file")
    XCTAssertEqual(line, expectedLine)
  }

  func test_set_shouldReturnValueFromBuilder() {
    // Given
    let expectedMockable = Mockable<Void>.stub()
    builder.mockablePredicatesReturn = expectedMockable

    // When
    let mockable = writable.set(true)

    // Then
    XCTAssertTrue(mockable === expectedMockable)
  }
}
