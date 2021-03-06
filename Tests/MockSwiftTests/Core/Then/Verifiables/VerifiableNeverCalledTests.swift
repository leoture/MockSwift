// VerifiableCalledTests.swift
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

class VerifiableNeverCalledTests: XCTestCase {
    private var callRegister: CallRegisterMock!
    private var functionIdentifier: FunctionIdentifier!
    private var failureRecorder: FailureRecorderMock!
    private var predicate: AnyPredicateMock!
    private var verifiable: Verifiable<Void>!

    override func setUp() {
        callRegister = CallRegisterMock()
        functionIdentifier = .stub(function: "function(arg:)", returnType: Int.self)
        failureRecorder = FailureRecorderMock()
        predicate = AnyPredicateMock()
        verifiable = Verifiable(callRegister: callRegister,
                                functionIdentifier: functionIdentifier,
                                parametersPredicates: [predicate],
                                failureRecorder: failureRecorder)
    }

    // MARK: - Private methods

    private func callRegisterCalled(with functionIdentifier: FunctionIdentifier, and predicate: AnyPredicateMock) {
        XCTAssertEqual(callRegister.recordedCallsReceived.count, 1)
        let (identifier, matchs) = callRegister.recordedCallsReceived[0]
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(matchs.count, 1)
        XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
    }

    func test_neverCalled_should_recordFailure_when_recordedCallsReturnCalls() {
        // Given
        callRegister.recordedCallsReturn = [.stub(), .stub()]
        predicate.description = "description"

        // When
        verifiable.neverCalled(file: "file", line: 42)

        // Then
        callRegisterCalled(with: functionIdentifier, and: predicate)

        XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
        let (message, file, line) = failureRecorder.recordFailureReceived[0]
        XCTAssertEqual(message, "function(arg: description) -> Int " +
                        "is expected to be called 0 time(s) but is called 2 time(s).")
        XCTAssertEqual("\(file) \(line)", "file 42")
    }

    func test_neverCalled_should_notRecordFailure_when_recordedCallsReturnNoCalls() {
        // Given
        callRegister.recordedCallsReturn = []

        // When
        verifiable.neverCalled()

        // Then
        XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
    }

    func test_neverCalledAfterAssertion_should_notRecordFailure_when_recordedCallsReturnEmpty() {
        // Given
        callRegister.recordedCallsReturn = []
        predicate.description = "description"
        let assertion = AssertionMock()
        assertion.descriptionReturn = "assertion description"
        assertion.isValidReturn = true
        assertion.firstValidTimeReturn = 0

        // When
        verifiable.neverCalled(after: assertion, file: "file", line: 42)

        // Then
        callRegisterCalled(with: functionIdentifier, and: predicate)

        XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
    }

    func test_neverCalledAfterAssertion_should_recordFailure_when_recordedCallsReturnCall() {
        // Given
        callRegister.recordedCallsReturn = [.stub(time: 0), .stub(time: 2)]
        predicate.description = "description"
        let assertion = AssertionMock()
        assertion.descriptionReturn = "assertion description"
        assertion.isValidReturn = true
        assertion.firstValidTimeReturn = 1

        // When
        verifiable.neverCalled(after: assertion, file: "file", line: 42)

        // Then
        XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
        let (message, file, line) = failureRecorder.recordFailureReceived[0]
        XCTAssertEqual(message, "function(arg: description) -> Int is expected to be called 0 time(s) " +
                        "but is called 1 time(s) " +
                        "after assertion description.")
        XCTAssertEqual("\(file) \(line)", "file 42")
    }

    func test_neverCalledAfterAssertion_should_recordFailure_when_previousAssertionIsNotValid() {
        // Given
        callRegister.recordedCallsReturn = []
        let assertion = AssertionMock()
        assertion.descriptionReturn = "assertion description"
        assertion.isValidReturn = false

        // When
        verifiable.neverCalled(after: assertion, file: "file", line: 42)

        // Then
        XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
        let (message, file, line) = failureRecorder.recordFailureReceived[0]
        XCTAssertEqual(message, "assertion description")
        XCTAssertEqual("\(file) \(line)", "file 42")
    }

    func test_neverCalledAfterAssertion_should_notRecordFailure_when_recordedCallsReturnNoCall() {
        // Given
        callRegister.recordedCallsReturn = [.stub(time: 0), .stub(time: 1)]
        let assertion = AssertionMock()
        assertion.isValidReturn = true
        assertion.firstValidTimeReturn = 2

        // When
        verifiable.neverCalled(after: assertion, file: "file", line: 42)

        // Then
        XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
    }

    func test_neverCalledAfterAssertion_should_returnCorrectAssertion() {
        // Given
        callRegister.recordedCallsReturn = [.stub(time: 0)]
        predicate.description = "description"
        let assertion = AssertionMock()
        assertion.isValidReturn = true
        assertion.firstValidTimeReturn = 1

        // When
        let result = verifiable.neverCalled(after: assertion, file: "file", line: 42)

        // Then
        XCTAssertTrue(result is CallAssertion)
        let callAssertion = result as? CallAssertion
        XCTAssertEqual(callAssertion?.times.description, (==0).description)
        XCTAssertEqual(callAssertion?.functionIdentifier, functionIdentifier)
        XCTAssertEqual(callAssertion?.parametersPredicates.map { $0.description }, [predicate.description])
        XCTAssertEqual(callAssertion?.calls.count, 0)
        XCTAssertTrue(callAssertion?.previous as AnyObject === assertion)
    }
}
