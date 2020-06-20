// VerifiableTests.swift
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

class VerifiableTests: XCTestCase {
  private var callRegister: CallRegisterMock!
  private var functionIdentifier: FunctionIdentifier!
  private var failureRecorder: FailureRecorderMock!

  override func setUp() {
    callRegister = CallRegisterMock()
    functionIdentifier = .stub(function: "function(arg:)", returnType: Int.self)
    failureRecorder = FailureRecorderMock()
  }

  func test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType() {
    // Given
    let verifiable = Verifiable(callRegister: callRegister,
                                functionIdentifier: functionIdentifier,
                                parametersPredicates: [],
                                failureRecorder: failureRecorder)
      .disambiguate(with: String.self)

    // When
    let disambiguatedVerifiable: Verifiable<String> = verifiable.disambiguate(with: String.self)

    // Then
    XCTAssertTrue(disambiguatedVerifiable === verifiable)
  }

  func test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatched() {
    // Given
    callRegister.recordedCallReturn = []
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int " +
      "is expected to be called more than 0 time(s) but is called 0 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatched() {
    // Given
    callRegister.recordedCallReturn = [.stub()]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called()

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimes() {
    // Given
    callRegister.recordedCallReturn = [.stub(), .stub()]
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: >2, file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int " +
      "is expected to be called more than 2 time(s) but is called 2 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimes() {
    // Given
    callRegister.recordedCallReturn = [.stub(), .stub(), .stub()]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: >2)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimesExactly() {
    // Given
    callRegister.recordedCallReturn = [.stub(), .stub()]
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: 3, file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int " +
      "is expected to be called 3 time(s) but is called 2 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimesExactly() {
    // Given
    callRegister.recordedCallReturn = [.stub(), .stub(), .stub()]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: 3)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_calledAfterAssertion_when_noFunctionCallFromCallRegister_should_recordFailure() {
    // Given
    callRegister.recordedCallReturn = []
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let assertion = Assertion(times: ==2,
                              functionIdentifier: .init(function: "otherFunction(arg:)", return: String.self),
                              parametersPredicates: [predicate],
                              file: "",
                              line: 0,
                              calls: [.stub(time: 1), .stub(time: 2)])
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)
    // When
    verifiable.called(times: >1, after: assertion, file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int is expected to be called more than 1 time(s) " +
      "but is called 0 time(s) " +
      "after otherFunction(arg: description) -> String has been called 2 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_calledAfterAssertion_when_notEnoughFunctionCallFound_should_recordFailure() {
    // Given
    callRegister.recordedCallReturn = [.stub(time: 0), .stub(time: 3)]
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let assertion = Assertion(times: >1,
                              functionIdentifier: .init(function: "otherFunction(arg:)", return: String.self),
                              parametersPredicates: [predicate],
                              file: "",
                              line: 0,
                              calls: [.stub(time: 1), .stub(time: 2)])
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)
    // When
    verifiable.called(times: >1, after: assertion, file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int is expected to be called more than 1 time(s) " +
      "but is called 1 time(s) " +
      "after otherFunction(arg: description) -> String has been called 2 time(s).")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_calledAfterAssertion_when_enoughFunctionCallFound_should_notRecordFailure() {
    // Given
    callRegister.recordedCallReturn = [.stub(time: 0), .stub(time: 3), .stub(time: 4)]
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let assertion = Assertion(times: >1,
                              functionIdentifier: .init(function: "otherFunction(arg:)", return: String.self),
                              parametersPredicates: [predicate],
                              file: "",
                              line: 0,
                              calls: [.stub(time: 1), .stub(time: 2)])
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)
    // When
    verifiable.called(times: >1, after: assertion, file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_receivedParameters_shouldReturnEmptyWhenNoFunctionCallFromCallRegisterMatched() {
    // Given
    callRegister.recordedCallReturn = []
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    let result = verifiable.receivedParameters

    // Then
    XCTAssertTrue(result.isEmpty)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_receivedParameters_shouldReturnAllCallsParametersWhenFunctionCallFromCallRegisterMatched() {
    // Given
    callRegister.recordedCallReturn = [FunctionCall(identifier: UUID(), parameters: ["arg1", 1], time: 0),
                                       FunctionCall(identifier: UUID(), parameters: ["arg2", 2], time: 0)]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    let result = verifiable.receivedParameters

    // Then
    XCTAssertEqual(result.count, 2)
    XCTAssertEqual(result[0].count, 2)
    XCTAssertEqual(result[0][0] as? String, "arg1")
    XCTAssertEqual(result[0][1] as? Int, 1)
    XCTAssertEqual(result[1].count, 2)
    XCTAssertEqual(result[1][0] as? String, "arg2")
    XCTAssertEqual(result[1][1] as? Int, 2)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_callCount_shouldReturnZeroWhenNoFunctionCallFromCallRegisterMatched() {
    // Given
    callRegister.recordedCallReturn = []
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    let result = verifiable.callCount

    // Then
    XCTAssertEqual(result, 0)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_callCount_shouldReturnNumberOfMatchedFunctionCallFromCallRegister() {
    // Given
    callRegister.recordedCallReturn = [.stub(), .stub()]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    let result = verifiable.callCount

    // Then
    XCTAssertEqual(result, 2)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }
}
