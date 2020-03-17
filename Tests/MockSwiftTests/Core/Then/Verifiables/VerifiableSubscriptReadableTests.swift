// VerifiableSubscriptReadableTests.swift
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

final class VerifiableSubscriptReadableTests: XCTestCase {
  private let builder = VerifiableBuilderMock()
  private let expectedFunction = "subcript(_:)"
  private let expectedLine: UInt = 1
  private let expectedPredicates = [1, 2]
  private let expectedVerifiable = Verifiable<Bool>.stub()
  private var readable: VerifiableSubscript.Readable<Bool>!

  override func setUp() {
    builder.verifiablePredicatesReturn = expectedVerifiable
    readable = VerifiableSubscript.Readable<Bool>(function: expectedFunction,
                                                  file: "file",
                                                  line: expectedLine,
                                                  verifiableBuilder: builder,
                                                  predicates: expectedPredicates)
  }

  func test_get_shouldCorrectlyCallBuilder() {
    // Given

    // When
    _ = readable.get

    // Then
    XCTAssertEqual(builder.verifiablePredicatesReceived.count, 1)
    let (parameters, function, file, line) = builder.verifiablePredicatesReceived[0]
    XCTAssertEqual(parameters as? [Int], [1, 2])
    XCTAssertEqual(function, expectedFunction)
    XCTAssertEqual(file, "file")
    XCTAssertEqual(line, expectedLine)
  }

  func test_get_shouldReturnValueFromBuilder() {
    // Given

    // When
    let verifiable = readable.get

    // Then
    XCTAssertTrue(verifiable === expectedVerifiable)
  }
}
