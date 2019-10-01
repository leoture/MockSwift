//VerifiableTests.swift
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

import XCTest
@testable import MockSwift

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

    //Then
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

    //Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) ->" +
      " Int expect to be called more than 0 time(s) but is call 0 time(s)")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatched() {
    // Given
    callRegister.recordedCallReturn = [FunctionCall(parameters: [])]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called()

    //Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimes() {
    // Given
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: >2, file: "file", line: 42)

    //Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) ->" +
      " Int expect to be called more than 2 time(s) but is call 2 time(s)")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimes() {
    // Given
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: >2)

    //Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }

  func test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimesExactly() {
    // Given
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    predicate.description = "description"
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: 3, file: "file", line: 42)

    //Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "function(arg: description) -> Int expect to be called 3 time(s) but is call 2 time(s)")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimesExactly() {
    // Given
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    verifiable.called(times: 3)

    //Then
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let (identifier, matchs) = callRegister.recordedCallReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)

    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }
}
