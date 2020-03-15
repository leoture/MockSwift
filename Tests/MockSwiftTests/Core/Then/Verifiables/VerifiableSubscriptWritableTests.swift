// VerifiableSubcriptWritableTests.swift
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
@testable import MockSwift
import XCTest

final class VerifiableSubcriptWritableTests: XCTestCase {
  private let builder = VerifiableBuilderMock()
  private let expectedSubcript = "subcript(_:)"
  private let expectedLine: UInt = 1
  private let expectedPredicates = [1, 2]
  private var writable: VerifiableSubscript.Writable<Bool>!

  override func setUp() {
    writable = VerifiableSubscript.Writable<Bool>(function: expectedSubcript,
                                                  file: "file",
                                                  line: expectedLine,
                                                  verifiableBuilder: builder,
                                                  predicates: expectedPredicates)
  }

  func test_get_shouldCorrectlyCallBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Bool>.stub()
    builder.verifiablePredicatesReturn = expectedVerifiable

    // When
    _ = writable.get

    // Then
    XCTAssertEqual(builder.verifiablePredicatesReceived.count, 1)
    let (parameters, function, file, line) = builder.verifiablePredicatesReceived[0]
    XCTAssertEqual(parameters as? [Int], expectedPredicates)
    XCTAssertEqual(function, expectedSubcript)
    XCTAssertEqual(file, "file")
    XCTAssertEqual(line, expectedLine)
  }

  func test_get_shouldReturnValueFromBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Bool>.stub()
    builder.verifiablePredicatesReturn = expectedVerifiable

    // When
    let verifiable = writable.get

    // Then
    XCTAssertTrue(verifiable === expectedVerifiable)
  }

  func test_set_shouldCorrectlyCallBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Void>.stub()
    builder.verifiablePredicatesReturn = expectedVerifiable

    // When
    _ = writable.set(true)

    // Then
    XCTAssertEqual(builder.verifiablePredicatesReceived.count, 1)
    let (parameters, function, file, line) = builder.verifiablePredicatesReceived[0]
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? Int, 1)
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(function, expectedSubcript)
    XCTAssertEqual(file, "file")
    XCTAssertEqual(line, expectedLine)
  }

  func test_set_shouldReturnValueFromBuilder() {
    // Given
    let expectedVerifiable = Verifiable<Void>.stub()
    builder.verifiablePredicatesReturn = expectedVerifiable

    // When
    let verifiable = writable.set(true)

    // Then
    XCTAssertTrue(verifiable === expectedVerifiable)
  }
}
