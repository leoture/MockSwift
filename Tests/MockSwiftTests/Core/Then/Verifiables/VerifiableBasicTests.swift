//VerifiableBasicTests.swift
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

class VerifiableBasicTests: XCTestCase {
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

  // MARK: - receivedParameters

  func test_receivedParameters_should_returnEmpty_when_recordedCallsReturnEmpty() {
    // Given
    callRegister.recordedCallsReturn = []

    // When
    let result = verifiable.receivedParameters

    // Then
    XCTAssertTrue(result.isEmpty)
    let (identifier, matchs) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_receivedParameters_should_returnAllCallsParameters_when_recordedCallsReturnCalls() {
    // Given
    callRegister.recordedCallsReturn = [FunctionCall(identifier: UUID(), parameters: ["arg1", 1], time: 0),
                                       FunctionCall(identifier: UUID(), parameters: ["arg2", 2], time: 0)]
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
    let (identifier, matchs) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }

  // MARK: - callCount

  func test_callCount_should_returnZero_when_recordedCallsReturnEmpty() {
    // Given
    callRegister.recordedCallsReturn = []
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    let result = verifiable.callCount

    // Then
    XCTAssertEqual(result, 0)
    let (identifier, matchs) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_callCount_should_returnNumberOfCall_when_recordedCallsReturnCalls() {
    // Given
    callRegister.recordedCallsReturn = [.stub(), .stub()]
    let verifiable: Verifiable<Void> = Verifiable(callRegister: callRegister,
                                                  functionIdentifier: functionIdentifier,
                                                  parametersPredicates: [predicate],
                                                  failureRecorder: failureRecorder)

    // When
    let result = verifiable.callCount

    // Then
    XCTAssertEqual(result, 2)
    let (identifier, matchs) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(matchs.count, 1)
    XCTAssertTrue(matchs[0] as? AnyPredicateMock === predicate)
  }

  // MARK: - disambiguate

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

}
