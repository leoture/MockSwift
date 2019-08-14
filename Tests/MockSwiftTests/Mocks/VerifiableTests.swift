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

  func test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType() {
    // Given
    let verifiable = Verifiable(CallRegisterMock(), .stub(), []).disambiguate(with: String.self)

    // When
    let disambiguatedVerifiable: Verifiable<String> = verifiable.disambiguate(with: String.self)

    //Then
    XCTAssertTrue(disambiguatedVerifiable === verifiable)
  }

  func test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatched() {
    // Given
    let callRegister = CallRegisterMock()
    callRegister.recordedCallReturn = []
    let predicate = AnyPredicateMock()
    let functionIdentifier = FunctionIdentifier.stub()
    let verifiable: Verifiable<Void> = Verifiable(callRegister, functionIdentifier, [predicate])

    // When
    let result = verifiable.called()

    //Then
    XCTAssertFalse(result)
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let parameters = callRegister.recordedCallReceived[0]
    XCTAssertEqual(parameters.identifier, functionIdentifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue(parameters.matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_called_shouldReturnTrueWhenFunctionCallFromCallRegisterMatched() {
    // Given
    let callRegister = CallRegisterMock()
    callRegister.recordedCallReturn = [FunctionCall(parameters: [])]
    let predicate = AnyPredicateMock()
    let functionIdentifier = FunctionIdentifier.stub()
    let verifiable: Verifiable<Void> = Verifiable(callRegister, functionIdentifier, [predicate])

    // When
    let result = verifiable.called()

    //Then
    XCTAssertTrue(result)
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let parameters = callRegister.recordedCallReceived[0]
    XCTAssertEqual(parameters.identifier, functionIdentifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue(parameters.matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatchedTimes() {
    // Given
    let callRegister = CallRegisterMock()
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    let functionIdentifier = FunctionIdentifier.stub()
    let verifiable: Verifiable<Void> = Verifiable(callRegister, functionIdentifier, [predicate])

    // When
    let result = verifiable.called(times: >2)

    //Then
    XCTAssertFalse(result)
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let parameters = callRegister.recordedCallReceived[0]
    XCTAssertEqual(parameters.identifier, functionIdentifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue(parameters.matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_called_shouldReturnTrueWhenFunctionCallFromCallRegisterMatchedTimes() {
    // Given
    let callRegister = CallRegisterMock()
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    let functionIdentifier = FunctionIdentifier.stub()
    let verifiable: Verifiable<Void> = Verifiable(callRegister, functionIdentifier, [predicate])

    // When
    let result = verifiable.called(times: >2)

    //Then
    XCTAssertTrue(result)
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let parameters = callRegister.recordedCallReceived[0]
    XCTAssertEqual(parameters.identifier, functionIdentifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue(parameters.matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatchedTimesExactly() {
    // Given
    let callRegister = CallRegisterMock()
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    let functionIdentifier = FunctionIdentifier.stub()
    let verifiable: Verifiable<Void> = Verifiable(callRegister, functionIdentifier, [predicate])

    // When
    let result = verifiable.called(times: 3)

    //Then
    XCTAssertFalse(result)
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let parameters = callRegister.recordedCallReceived[0]
    XCTAssertEqual(parameters.identifier, functionIdentifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue(parameters.matchs[0] as? AnyPredicateMock === predicate)
  }

  func test_called_shouldReturnTrueWhenFunctionCallFromCallRegisterMatchedTimesExactly() {
    // Given
    let callRegister = CallRegisterMock()
    callRegister.recordedCallReturn = [
      FunctionCall(parameters: []),
      FunctionCall(parameters: []),
      FunctionCall(parameters: [])
    ]
    let predicate = AnyPredicateMock()
    let functionIdentifier = FunctionIdentifier.stub()
    let verifiable: Verifiable<Void> = Verifiable(callRegister, functionIdentifier, [predicate])

    // When
    let result = verifiable.called(times: 3)

    //Then
    XCTAssertTrue(result)
    XCTAssertEqual(callRegister.recordedCallReceived.count, 1)
    let parameters = callRegister.recordedCallReceived[0]
    XCTAssertEqual(parameters.identifier, functionIdentifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue(parameters.matchs[0] as? AnyPredicateMock === predicate)
  }
  static var allTests = [
    ("test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType",
     test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType),

    ("test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatched",
     test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatched),

    ("test_called_shouldReturnTrueWhenFunctionCallFromCallRegisterMatched",
     test_called_shouldReturnTrueWhenFunctionCallFromCallRegisterMatched),

    ("test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatchedTimes",
     test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatchedTimes),

    ("test_called_shouldReturnTrueWhenFunctionCallFromCallRegisterMatchedTimes",
     test_called_shouldReturnTrueWhenFunctionCallFromCallRegisterMatchedTimes),

    ("test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatchedTimesExactly",
     test_called_shouldReturnFalseWhenNoFunctionCallFromCallRegisterMatchedTimesExactly)
  ]
}
