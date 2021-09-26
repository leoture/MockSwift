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
        let call1 = FunctionCall(identifier: UUID(),
                                 parameters: [1],
                                 time: 1)
        let call2 = FunctionCall(identifier: UUID(),
                                 parameters: ["2"],
                                 time: 2)
        // When
        clock.currentTimeReturn = 0
        functionCallRegister.recordCall(call1, for: functionIdentifier)
        clock.currentTimeReturn = 1
        functionCallRegister.recordCall(call2, for: functionIdentifier)

        // Then
        XCTAssertEqual(functionCallRegister.unverifiedCalls.count, 2)

        XCTAssertEqual(functionCallRegister.calls.count, 1)
        let calls = functionCallRegister.calls[functionIdentifier]
        XCTAssertEqual(calls?.count, 2)
        XCTAssertEqual(calls?[0], call1)
        XCTAssertEqual(calls?[1], call2)

        XCTAssertEqual(functionCallRegister.unverifiedCalls[0], call1.identifier)
        XCTAssertEqual(functionCallRegister.unverifiedCalls[1], call2.identifier)
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
        functionCallRegister.recordCall(FunctionCall(identifier: UUID(),
                                                     parameters: [0],
                                                     time: 1),
                                        for: .stub())

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

        let call1 = FunctionCall(identifier: UUID(),
                                 parameters: [1],
                                 time: 1)
        let call2 = FunctionCall(identifier: UUID(),
                                 parameters: [2],
                                 time: 2)
        functionCallRegister.recordCall(call1, for: .stub())
        functionCallRegister.recordCall(call2, for: .stub())
        functionCallRegister.recordCall(FunctionCall(identifier: UUID(),
                                                     parameters: [3],
                                                     time: 3),
                                        for: .stub())

        let predicate = Predicate<Int>.match { $0 == 1 || $0 == 2 }

        // When
        let calls = functionCallRegister.recordedCalls(for: .stub(), when: [predicate])

        // Then
        XCTAssertEqual(calls.count, 2)
        XCTAssertEqual(calls[0], call1)
        XCTAssertEqual(calls[1], call2)
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
        let call = FunctionCall()
        functionCallRegister.recordCall(call, for: .stub())
        functionCallRegister.recordCall(FunctionCall(), for: .stub())
        functionCallRegister.makeCallVerified(for: call.identifier)

        // When
        let result = functionCallRegister.allCallHaveBeenVerified

        // Then
        XCTAssertFalse(result)
    }

    func test_allCallHaveBeenVerified_whenAllCallsHasBeenVerifiedShouldReturnFalse() {
        // Given
        let call1 = FunctionCall()
        let call2 = FunctionCall()
        functionCallRegister.recordCall(call1, for: .stub())
        functionCallRegister.recordCall(call2, for: .stub())
        [call1, call2].forEach { self.functionCallRegister.makeCallVerified(for: $0.identifier) }

        // When
        let result = functionCallRegister.allCallHaveBeenVerified

        // Then
        XCTAssertTrue(result)
    }

    // MARK: - unverifiedCalls

    func test_unverifiedCalls_whenCallHasNotBeenRecordedShouldReturnEmpty() {
        // Given

        // When
        let result = functionCallRegister.unverifiedCalls

        // Then
        XCTAssertTrue(result.isEmpty)
    }

    func test_unverifiedCalls_whenNotAllCallsHasBeenVerifiedShouldReturnCorrectIdentifiers() {
        // Given
        let call1 = FunctionCall(parameters: [0])
        let call2 = FunctionCall(parameters: [1])
        functionCallRegister.recordCall(call1, for: .stub())
        functionCallRegister.recordCall(call2, for: .stub())
        functionCallRegister.makeCallVerified(for: call1.identifier)

        // When
        let result = functionCallRegister.unverifiedCalls

        // Then
        XCTAssertEqual(result, [call2.identifier])
    }

        func test_unverifiedCalls_whenAllCallsHasBeenVerifiedShouldReturnEmpty() {
          // Given
            let call1 = FunctionCall(parameters: [0])
            let call2 = FunctionCall(parameters: [1])
            functionCallRegister.recordCall(call1, for: .stub())
            functionCallRegister.recordCall(call2, for: .stub())
            [call1, call2].forEach { functionCallRegister.makeCallVerified(for: $0.identifier) }

          // When
          let result = functionCallRegister.unverifiedCalls

          // Then
            XCTAssertTrue(result.isEmpty)
        }
}
