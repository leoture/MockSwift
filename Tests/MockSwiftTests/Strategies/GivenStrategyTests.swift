// GivenStrategyTests.swift
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

final class GivenStrategyTests: XCTestCase {
  private var givenStrategy: GivenStrategy!
  private var nextStrategy: StrategyMock!
  private var behaviourRegister: BehaviourRegisterMock!
  private var errorHandler: ErrorHandlerMock!

  override func setUp() {
    behaviourRegister = BehaviourRegisterMock()
    errorHandler = ErrorHandlerMock()
    nextStrategy = StrategyMock()
    givenStrategy = GivenStrategy(next: nextStrategy,
                                  behaviourRegister: behaviourRegister,
                                  errorHandler: errorHandler)
  }

  func test_resolve_shouldReturnFromNextStrategyWhenNoBehaviourFound() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
    behaviourRegister.recordedBehavioursReturn = []
    nextStrategy.resolveReturn = "next"

    // When
    let result: String = givenStrategy.resolve(for: functionIdentifier,
                                               concernedBy: ["parameter1", 2, true])

    // Then
    XCTAssertEqual(nextStrategy.resolveReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(result, "next")
  }

  func test_resolve_shouldReturnFromNextStrategyWhenReturnTypeKO() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in 0 }]
    nextStrategy.resolveReturn = "next"

    // When
    let result: String = givenStrategy.resolve(for: functionIdentifier,
                                               concernedBy: ["parameter1", 2, true])

    // Then
    XCTAssertEqual(nextStrategy.resolveReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(result, "next")
  }

  func test_resolve_shouldFailWithTooManyDefinedBehaviour() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in "" },
                                                  FunctionBehaviour { _ in "" }]
    errorHandler.handleReturn = "error"

    // When
    let result: String = givenStrategy.resolve(for: functionIdentifier, concernedBy: parameters)

    // Then
    XCTAssertEqual(errorHandler.handleReceived[0], .tooManyDefinedBehaviour(for: functionIdentifier, with: parameters))
    XCTAssertEqual(result, "error")
  }

  func test_resolve_shouldReturnValueFromBehaviour() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: UUID.self)
    let uuid = UUID()
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in uuid }]

    // When
    let result: UUID = givenStrategy.resolve(for: functionIdentifier, concernedBy: ["parameter1", 2, true])

    // Then
    XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
    let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(result, uuid)
  }

  func test_resolveVoid_shouldFailWithNoDefinedBehaviour() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: Void.self)
    behaviourRegister.recordedBehavioursReturn = []
    nextStrategy.resolveReturn = ()

    // When
    givenStrategy.resolve(for: functionIdentifier,
                          concernedBy: ["parameter1", 2, true]) as Void

    // Then
    XCTAssertEqual(nextStrategy.resolveReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
  }

  func test_resolveVoid_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: Void.self)
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in 0 }]
    nextStrategy.resolveReturn = ()

    // When
    givenStrategy.resolve(for: functionIdentifier,
                          concernedBy: ["parameter1", 2, true]) as Void

    // Then
    XCTAssertEqual(nextStrategy.resolveReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
  }

  func test_resolveVoid_shouldFailWithTooManyDefinedBehaviour() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: Void.self)
    let parameters: [ParameterType] = ["parameter1", 2, true]
    behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in },
                                                  FunctionBehaviour { _ in }]
    errorHandler.handleReturn = ()

    // When
    givenStrategy.resolve(for: functionIdentifier, concernedBy: parameters) as Void

    // Then
    XCTAssertEqual(errorHandler.handleReceived[0], .tooManyDefinedBehaviour(for: functionIdentifier, with: parameters))
  }
}
