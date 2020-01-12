//MockTests.swift
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

private protocol AnyProtocol {}

final class MockTests: XCTestCase {
  private var mock: Mock<AnyProtocol>!
  private var callRegister: CallRegisterMock!
  private var strategy: StrategyMock!
  private var errorHandler: ErrorHandlerMock!

  override func setUp() {
    callRegister = CallRegisterMock()
    strategy = StrategyMock()
    errorHandler = ErrorHandlerMock()
    mock = Mock(callRegister: callRegister,
                behaviourRegister: BehaviourRegisterMock(),
                strategy: strategy,
                errorHandler: errorHandler)
  }

  func test_wrappedValue_shouldFailWithCast() {
    // Given
    let mock = Mock<Int>(callRegister: CallRegisterMock(),
                         behaviourRegister: BehaviourRegisterMock(),
                         strategy: strategy,
                         errorHandler: errorHandler)
    errorHandler.handleReturn = 0

    // When
    let result = mock.wrappedValue

    // Then
    XCTAssertEqual(errorHandler.handleReceived[0], .cast(source: mock, target: Int.self))
    XCTAssertEqual(result, 0)
  }

  func test_mocked_shouldRecordCallIntoCallRegister() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) -> String {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    strategy.resolveReturn =  ""

    // When
    _ = function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    XCTAssertEqual(callRegister.recordCallReceived.count, 1)
    let (identifier, parameters) = callRegister.recordCallReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: String.self))
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
  }

  func test_mocked_shouldReturnValueFromStrategy() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) -> UUID {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    let uuid = UUID()
    strategy.resolveReturn = uuid

    // When
    let result = function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    XCTAssertEqual(strategy.resolveReceived.count, 1)
    let (identifier, parameters) = strategy.resolveReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: UUID.self))
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(result, uuid)
  }

  func test_mockedVoid_shouldRecordCallIntoCallRegister() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    strategy.resolveReturn = ()

    // When
    function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    XCTAssertEqual(callRegister.recordCallReceived.count, 1)
    let (identifier, parameters) = callRegister.recordCallReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: Void.self))
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
  }

  func test_mockedVoid_shouldCallStrategy() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) {
      mock.mocked(parameter1, parameter2, parameter3)
    }

    strategy.resolveReturn = ()

    // When
    function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    XCTAssertEqual(strategy.resolveReceived.count, 1)
    let (identifier, parameters) = strategy.resolveReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: Void.self))
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
  }
}
