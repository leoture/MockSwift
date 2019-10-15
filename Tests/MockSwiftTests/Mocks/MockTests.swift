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
  private var behaviourRegister: BehaviourRegisterMock!
  private var errorHandler: ErrorHandlerMock!

  override func setUp() {
    callRegister = CallRegisterMock()
    behaviourRegister = BehaviourRegisterMock()
    errorHandler = ErrorHandlerMock()
    mock = Mock(callRegister: callRegister, behaviourRegister: behaviourRegister, errorHandler: errorHandler)
  }

  func test_wrappedValue_shouldFailWithCast() {
    // Given
    let mock = Mock<Int>(callRegister: callRegister, behaviourRegister: behaviourRegister, errorHandler: errorHandler)
    errorHandler.handleReturn = 0

    // When
    let result = mock.wrappedValue

    // Then
    XCTAssertEqual(errorHandler.handleReceived[0], .cast(source: mock, target: Int.self))
    XCTAssertEqual(result, 0)
  }

  func test_mocked_shouldFailWithNoDefinedBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) -> String {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = []
    errorHandler.handleReturn = "error"

    // When
    let result = function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    let functionIdentifier = FunctionIdentifier(function: functionName, return: String.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    XCTAssertEqual(errorHandler.handleReceived[0], .noDefinedBehaviour(for: functionIdentifier, with: parameters))
    XCTAssertEqual(result, "error")
  }

  func test_mocked_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) -> String {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in 0 }]
    errorHandler.handleReturn = "error"

    // When
    let result = function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    let functionIdentifier = FunctionIdentifier(function: functionName, return: String.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    XCTAssertEqual(errorHandler.handleReceived[0], .noDefinedBehaviour(for: functionIdentifier, with: parameters))
    XCTAssertEqual(result, "error")
  }

  func test_mocked_shouldFailWithTooManyDefinedBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) -> String {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = [
      FunctionBehaviour { _ in "" },
      FunctionBehaviour { _ in "" }
    ]
    errorHandler.handleReturn = "error"

    // When
    let result = function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    let functionIdentifier = FunctionIdentifier(function: functionName, return: String.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    XCTAssertEqual(errorHandler.handleReceived[0], .tooManyDefinedBehaviour(for: functionIdentifier, with: parameters))
    XCTAssertEqual(result, "error")
  }

  func test_mocked_shouldRecordCallIntoCallRegister() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) -> String {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in "" }]

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

  func test_mocked_shouldReturnValueFromBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) -> UUID {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    let uuid = UUID()
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in uuid }]

    // When
    let result = function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
    let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: UUID.self))
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(result, uuid)
  }

  func test_mockedVoid_shouldFailWithNoDefinedBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = []
    errorHandler.handleReturn = ()

    // When
    function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    let functionIdentifier = FunctionIdentifier(function: functionName, return: Void.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    XCTAssertEqual(errorHandler.handleReceived[0], .noDefinedBehaviour(for: functionIdentifier, with: parameters))
  }

  func test_mockedVoid_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in 0 }]
    errorHandler.handleReturn = ()

    // When
    function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    let functionIdentifier = FunctionIdentifier(function: functionName, return: Void.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    XCTAssertEqual(errorHandler.handleReceived[0], .noDefinedBehaviour(for: functionIdentifier, with: parameters))
  }

  func test_mockedVoid_shouldFailWithTooManyDefinedBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = [
      FunctionBehaviour { _ in  },
      FunctionBehaviour { _ in  }
    ]
    errorHandler.handleReturn = ()

    // When
    function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    let functionIdentifier = FunctionIdentifier(function: functionName, return: Void.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    XCTAssertEqual(errorHandler.handleReceived[0], .tooManyDefinedBehaviour(for: functionIdentifier, with: parameters))
  }

  func test_mockedVoid_shouldRecordCallIntoCallRegister() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) {
      mock.mocked(parameter1, parameter2, parameter3)
    }
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in }]

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

  func test_mockedVoid_shouldCallBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:parameter3:)"
    func function(parameter1: String, parameter2: Int, parameter3: Bool?) {
      mock.mocked(parameter1, parameter2, parameter3)
    }

    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in }]

    // When
    function(parameter1: "parameter1", parameter2: 2, parameter3: true)

    //Then
    XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
    let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: Void.self))
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
  }
}
