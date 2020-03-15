// FunctionCallRegisterTests.swift
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

@testable import MockSwift
import XCTest

class FunctionCallRegisterTests: XCTestCase {
  private var functionCallRegister: FunctionCallRegister!

  override func setUp() {
    functionCallRegister = FunctionCallRegister()
  }

  func test_recordedCalls_shouldReturnEmptyWhenNoFunctionCall() {
    // Given
    let predicate = AnyPredicateMock()

    // When
    let calls = functionCallRegister.recordedCall(for: .stub(), when: [predicate])

    // Then
    XCTAssertTrue(calls.isEmpty)
  }

  func test_recordedCalls_shouldReturnEmptyWhenNoFunctionCallMatched() {
    // Given
    let predicate = AnyPredicateMock()
    predicate.satisfyReturn = false
    functionCallRegister.recordCall(for: .stub(), with: [0])

    // When
    let calls = functionCallRegister.recordedCall(for: .stub(), when: [predicate])

    // Then
    XCTAssertTrue(calls.isEmpty)
  }

  func test_recordedCalls_shouldReturnFunctionCallsMatched() {
    // Given
    let predicateTrue = AnyPredicateMock()
    predicateTrue.satisfyReturn = true
    let predicateFalse = AnyPredicateMock()
    predicateFalse.satisfyReturn = false

    let firstParameter = UUID()
    let secondParameter = UUID()
    functionCallRegister.recordCall(for: .stub(), with: [firstParameter])
    functionCallRegister.recordCall(for: .stub(), with: [secondParameter])
    functionCallRegister.recordCall(for: .stub(), with: [UUID()])

    let predicate = Predicate<UUID>.match { $0 == firstParameter || $0 == secondParameter }

    // When
    let calls = functionCallRegister.recordedCall(for: .stub(), when: [predicate])

    // Then
    XCTAssertEqual(calls.count, 2)
    XCTAssertEqual(calls[0].parameters[0] as? UUID, firstParameter)
    XCTAssertEqual(calls[1].parameters[0] as? UUID, secondParameter)
  }
}
