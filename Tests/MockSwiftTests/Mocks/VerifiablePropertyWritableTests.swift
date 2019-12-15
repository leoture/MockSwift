//VerifiablePropertyWritableTests.swift
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

final class VerifiablePropertyWritableTests: XCTestCase {

  private let builder = VerifiableBuilderMock()
  private let expectedProperty = "property"
  private let expectedLine: UInt = 1
  private var writable: VerifiableProperty.Writable<Bool>!

  override  func setUp() {
    writable = VerifiableProperty.Writable<Bool>(property: expectedProperty,
                                                 file: "file",
                                                 line: expectedLine,
                                                 verifiableBuilder: builder)
  }

  func test_get_shouldCorrectlyCallBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Bool>.stub()
    builder.verifiableReturn = expectedVerifiable

    // When
    _  = writable.get

    // Then
    XCTAssertEqual(builder.verifiableReceived.count, 1)
    let (parameters, function, file, line) = builder.verifiableReceived[0]
    XCTAssertTrue(parameters.isEmpty)
    XCTAssertEqual(function, expectedProperty)
    XCTAssertEqual(file, "file")
    XCTAssertEqual(line, expectedLine)
  }

  func test_get_shouldReturnValueFromBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Bool>.stub()
    builder.verifiableReturn = expectedVerifiable

    // When
    let verifiable = writable.get

    // Then
    XCTAssertTrue(verifiable === expectedVerifiable)
  }

  func test_set_shouldCorrectlyCallBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Void>.stub()
    builder.verifiableReturn = expectedVerifiable

    // When
    _  = writable.set(true)

    // Then
    XCTAssertEqual(builder.verifiableReceived.count, 1)
    let (parameters, function, file, line) = builder.verifiableReceived[0]
    XCTAssertEqual(parameters.count, 1)
    XCTAssertEqual(parameters[0] as? Bool, true)
    XCTAssertEqual(function, expectedProperty)
    XCTAssertEqual(file, "file")
    XCTAssertEqual(line, expectedLine)
  }

  func test_set_shouldReturnValueFromBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Void>.stub()
    builder.verifiableReturn = expectedVerifiable

    // When
    let verifiable = writable.set(true)

    // Then
    XCTAssertTrue(verifiable === expectedVerifiable)
  }
}
