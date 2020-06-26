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

class VerifiableCalledTests: XCTestCase {
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

  // MARK: - called times:Predicate<Int>

  func test_called_should_recordFailure_when_recordedCallsReturnEmpty() {
    // Given
    callRegister.recordedCallsReturn = []
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallsReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int " +
      "is expected to be called more than 0 time(s) but is called 0 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_should_notRecordFailure_when_recordedCallsReturnCalls() {
    // Given
    callRegister.recordedCallsReturn = [.stub()]
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [AnyPredicateMock()],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(file: "file", line: 42)

    // Then
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_called_should_recordFailure_when_recordedCallsDontReturnEnoughCalls() {
    // Given
    callRegister.recordedCallsReturn = [.stub(), .stub()]
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: >2, file: "file", line: 42)

    // Then
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int " +
      "is expected to be called more than 2 time(s) but is called 2 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_should_notRecordFailure_when_recordedCallsReturnEnoughCalls() {
    // Given
    callRegister.recordedCallsReturn = [.stub(), .stub(), .stub()]
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [AnyPredicateMock()],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: >2)

    // Then
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  // MARK: - called times:Int

  func test_called_should_recordFailure_when_recordedCallsDontReturnExactNumberOfCalls() {
    // Given
    callRegister.recordedCallsReturn = [.stub(), .stub()]
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: 3, file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallsReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int " +
      "is expected to be called 3 time(s) but is called 2 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_should_notRecordFailure_when_recordedCallsReturnExactNumberOfCalls() {
    // Given
    callRegister.recordedCallsReturn = [.stub(), .stub(), .stub()]
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [AnyPredicateMock()],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: 3)

    // Then
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  // MARK: - called after Assertion

  func test_calledAfterAssertion_should_recordFailure_when_recordedCallsReturnEmpty() {
    // Given
    callRegister.recordedCallsReturn = []
    predicate.description = "description"
    let assertion = AssertionMock()
    assertion.descriptionReturn = "assertion description"
    assertion.firstValidTimeReturn = 0
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)
    // When
    verifiable.called(times: >1, after: assertion, file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallsReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int is expected to be called more than 1 time(s) " +
      "but is called 0 time(s) " +
      "after assertion description.")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_calledAfterAssertion_should_recordFailure_when_recordedCallsDontReturnEnoughFunctionCall() {
    // Given
    callRegister.recordedCallsReturn = [.stub(time: 0), .stub(time: 3)]
    predicate.description = "description"
    let assertion = AssertionMock()
    assertion.descriptionReturn = "assertion description"
    assertion.firstValidTimeReturn = 2
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)
    // When
    verifiable.called(times: >1, after: assertion, file: "file", line: 42)

    // Then
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int is expected to be called more than 1 time(s) " +
      "but is called 1 time(s) " +
      "after assertion description.")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_calledAfterAssertion_should_notRecordFailure_when_recordedCallsReturnEnoughFunctionCall() {
    // Given
    callRegister.recordedCallsReturn = [.stub(time: 0), .stub(time: 3), .stub(time: 4)]
    let assertion = AssertionMock()
    assertion.firstValidTimeReturn = 2
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [AnyPredicateMock()],
                                                  failureRecorder: failureRecorder)
    // When
    verifiable.called(times: >1, after: assertion, file: "file", line: 42)

    // Then
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_calledAfterAssertion_should_returnCorrectAssertion() {
    // Given
    let expectedCall1: FunctionCall = .stub(time: 3)
    let expectedCall2: FunctionCall = .stub(time: 4)
    callRegister.recordedCallsReturn = [.stub(time: 0), expectedCall1, expectedCall2]
    predicate.description = "description"
    let assertion = AssertionMock()
    assertion.firstValidTimeReturn = 2
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)
    // When
    let result = verifiable.called(times: >=2, after: assertion, file: "file", line: 42)

    // Then
    XCTAssertTrue(result is CallAssertion)
    let callAssertion = result as? CallAssertion
    XCTAssertEqual(callAssertion?.times.description, (>=2).description)
    XCTAssertEqual(callAssertion?.functionIdentifier, functionIdentifier)
    XCTAssertEqual(callAssertion?.parametersPredicates.map { $0.description }, [predicate.description])
    XCTAssertEqual(callAssertion?.calls, [expectedCall1, expectedCall2])
    XCTAssertTrue(callAssertion?.previous as AnyObject === assertion)
  }
}
