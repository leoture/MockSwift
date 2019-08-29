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

  override func setUp() {
    callRegister = CallRegisterMock()
    behaviourRegister = BehaviourRegisterMock()
    mock = Mock(callRegister: callRegister, behaviourRegister: behaviourRegister)
  }

  func test_mocked_shouldRecordCallIntoCallRegister() {
    // Given
    let functionName = "function(parameter1:parameter2:)"
    func function(parameter1: String, parameter2: Int) -> String {
      mock.mocked(parameter1, parameter2)
    }
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in "" }]

    // When
    _ = function(parameter1: "parameter1", parameter2: 2)

    //Then
    XCTAssertEqual(callRegister.recordCallReceived.count, 1)
    let (identifier, parameters) = callRegister.recordCallReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: String.self))
    XCTAssertEqual(parameters.count, 2)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
  }

  func test_mocked_shouldReturnValueFromBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:)"
    func function(parameter1: String, parameter2: Int) -> UUID {
      mock.mocked(parameter1, parameter2)
    }
    let uuid = UUID()
    let functionBehaviour = FunctionBehaviour { _ in uuid }
    behaviourRegister.recordedBehavioursReturn = [functionBehaviour]

    // When
    let result = function(parameter1: "parameter1", parameter2: 2)

    //Then
    XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
    let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: UUID.self))
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(result, uuid)
  }

  func test_mockedVoid_shouldRecordCallIntoCallRegister() {
    // Given
    let functionName = "function(parameter1:parameter2:)"
    func function(parameter1: String, parameter2: Int) {
      mock.mocked(parameter1, parameter2)
    }
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in }]

    // When
    function(parameter1: "parameter1", parameter2: 2)

    //Then
    XCTAssertEqual(callRegister.recordCallReceived.count, 1)
    let (identifier, parameters) = callRegister.recordCallReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: Void.self))
    XCTAssertEqual(parameters.count, 2)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
  }

  func test_mockedVoid_shouldCallBehaviour() {
    // Given
    let functionName = "function(parameter1:parameter2:)"
    func function(parameter1: String, parameter2: Int) {
      mock.mocked(parameter1, parameter2)
    }

    let functionBehaviour = FunctionBehaviour { _ in }
    behaviourRegister.recordedBehavioursReturn = [functionBehaviour]

    // When
    function(parameter1: "parameter1", parameter2: 2)

    //Then
    XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
    let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
    XCTAssertEqual(identifier, FunctionIdentifier(function: functionName, return: Void.self))
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
  }
}
