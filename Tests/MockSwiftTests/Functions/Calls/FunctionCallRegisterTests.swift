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
  private var clock: ClockMock!

  override func setUp() {
    clock = ClockMock()
    clock.currentTimeReturn = -1
    functionCallRegister = FunctionCallRegister(clock: clock)
  }

  // MARK: - recordCall

  func test_recordCall_should_addCorrectFunctionCalls() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub()

    // When
    clock.currentTimeReturn = 0
    functionCallRegister.recordCall(for: functionIdentifier, with: [1])
    clock.currentTimeReturn = 1
    functionCallRegister.recordCall(for: functionIdentifier, with: ["2"])

    // Then
    XCTAssertEqual(functionCallRegister.unverifiedCalls.count, 2)
    let uuid1 = functionCallRegister.unverifiedCalls[0]
    let uuid2 = functionCallRegister.unverifiedCalls[1]

    XCTAssertEqual(functionCallRegister.calls.count, 1)
    let calls = functionCallRegister.calls[functionIdentifier]
    XCTAssertEqual(calls?.count, 2)
    let call1 = calls?[0]
    XCTAssertEqual(call1?.identifier, uuid1)
    XCTAssertEqual(call1?.parameters as? [Int], [1])
    XCTAssertEqual(call1?.time, 0)
    let call2 = calls?[1]
    XCTAssertEqual(call2?.identifier, uuid2)
    XCTAssertEqual(call2?.parameters as? [String], ["2"])
    XCTAssertEqual(call2?.time, 1)
  }

  // MARK: - recordedCalls

  func test_recordedCalls_shouldReturnEmptyWhenNoFunctionCall() {
    // Given
    let predicate = AnyPredicateMock()

    // When
    let calls = functionCallRegister.recordedCalls(for: .stub(), when: [predicate])

    // Then
    XCTAssertTrue(calls.isEmpty)
  }

  func test_recordedCalls_shouldReturnEmptyWhenNoFunctionCallMatched() {
    // Given
    let predicate = AnyPredicateMock()
    predicate.satisfyReturn = false
    functionCallRegister.recordCall(for: .stub(), with: [0])

    // When
    let calls = functionCallRegister.recordedCalls(for: .stub(), when: [predicate])

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
    let calls = functionCallRegister.recordedCalls(for: .stub(), when: [predicate])

    // Then
    XCTAssertEqual(calls.count, 2)
    XCTAssertEqual(calls[0].parameters[0] as? UUID, firstParameter)
    XCTAssertEqual(calls[1].parameters[0] as? UUID, secondParameter)
  }

  // MARK: - allCallHaveBeenVerified

  func test_allCallHaveBeenVerified_whenCallHasNotBeenRecordedShouldReturnTrue() {
    // Given

    // When
    let result = functionCallRegister.allCallHaveBeenVerified

    // Then
    XCTAssertTrue(result)
  }

  func test_allCallHaveBeenVerified_whenNotAllCallsHasBeenVerifiedShouldReturnFalse() {
    // Given
    functionCallRegister.recordCall(for: .stub(), with: [0])
    functionCallRegister.recordCall(for: .stub(), with: [1])
    let calls = functionCallRegister.recordedCalls(for: .stub(), when: [0])
    calls.forEach { self.functionCallRegister.makeCallVerified(for: $0.identifier) }

    // When
    let result = functionCallRegister.allCallHaveBeenVerified

    // Then
    XCTAssertFalse(result)
  }

  func test_allCallHaveBeenVerified_whenAllCallsHasBeenVerifiedShouldReturnFalse() {
    // Given
    functionCallRegister.recordCall(for: .stub(), with: [0])
    functionCallRegister.recordCall(for: .stub(), with: [1])
    let calls = functionCallRegister.recordedCalls(for: .stub(), when: [Predicate<Any>.any()])
    calls.forEach { self.functionCallRegister.makeCallVerified(for: $0.identifier) }

    // When
    let result = functionCallRegister.allCallHaveBeenVerified

    // Then
    XCTAssertTrue(result)
  }
}
