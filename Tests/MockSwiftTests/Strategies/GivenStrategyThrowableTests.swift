// GivenStrategyThrowableTests.swift
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

final class GivenStrategyThrowableTests: XCTestCase {
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

    func test_resolveThrowable_shouldReturnFromNextStrategyWhenNoBehaviourFound() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
        behaviourRegister.recordedBehavioursReturn = []
        nextStrategy.resolveThrowableReturn = "next"

        // When
        let result: String? = try? givenStrategy.resolveThrowable(for: functionIdentifier,
                                                                     concernedBy: ["parameter1", 2, true])

        // Then
        XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
        let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertEqual(result, "next")
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }

    func test_resolveThrowable_shouldReturnFromNextStrategyWhenReturnTypeKO() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
        behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in 0 }]
        nextStrategy.resolveThrowableReturn = "next"

        // When
        let result: String? = try? givenStrategy.resolveThrowable(for: functionIdentifier,
                                                                     concernedBy: ["parameter1", 2, true])

        // Then
        XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
        let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertEqual(result, "next")
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }

    func test_resolveThrowable_shouldFailWithTooManyDefinedBehaviour() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
        let parameters: [ParameterType] = ["parameter1", 2, true]
        behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in "" },
                                                      FunctionBehaviour { _ in "" }]
        errorHandler.handleReturn = "error"

        // When
        let result: String? = try? givenStrategy.resolveThrowable(for: functionIdentifier, concernedBy: parameters)

        // Then
        XCTAssertEqual(errorHandler.handleReceived[0],
                       .tooManyDefinedBehaviour(for: functionIdentifier, with: parameters))
        XCTAssertEqual(result, "error")
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }

    func test_resolveThrowable_shouldReturnValueFromBehaviour() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: UUID.self)
        let uuid = UUID()
        let behaviour = FunctionBehaviour { _ in uuid }
        behaviourRegister.recordedBehavioursReturn = [behaviour]

        // When
        let result: UUID? = try? givenStrategy.resolveThrowable(for: functionIdentifier,
                                                                   concernedBy: ["parameter1", 2, true])

        // Then
        XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
        let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertEqual(result, uuid)
        XCTAssertEqual(behaviourRegister.makeBehaviourUsedReceived, [behaviour.identifier])
    }

    func test_resolveThrowable_shouldThrowErrorFromBehaviour() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
        let expectedError = NSError(domain: "domain", code: 0)
        let behaviour = FunctionBehaviour { _ in throw expectedError }
        behaviourRegister.recordedBehavioursReturn = [behaviour]

        // When
        var catchedError: NSError?
        do {
            _ = try givenStrategy.resolveThrowable(for: functionIdentifier,
                                                      concernedBy: ["parameter1", 2, true]) as String
        } catch {
            catchedError = error as NSError
        }

        // Then
        XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
        let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertTrue(catchedError === expectedError)
        XCTAssertEqual(behaviourRegister.makeBehaviourUsedReceived, [behaviour.identifier])
    }

    func test_resolveThrowable_shouldThrowErroFromNextStrategy() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: UUID.self)
        let expectedError = NSError(domain: "domain", code: 0)
        behaviourRegister.recordedBehavioursReturn = []
        nextStrategy.resolveThrowableError = expectedError

        // When
        var catchedError: NSError?
        do {
            _ = try givenStrategy.resolveThrowable(for: functionIdentifier,
                                                      concernedBy: ["parameter1", 2, true]) as UUID
        } catch {
            catchedError = error as NSError
        }

        // Then
        XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
        let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertTrue(catchedError === expectedError)
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }

    func test_resolveVoidThrowable_shouldFailWithNoDefinedBehaviour() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: Void.self)
        behaviourRegister.recordedBehavioursReturn = []
        nextStrategy.resolveThrowableReturn = ()

        // When
        try? givenStrategy.resolveThrowable(for: functionIdentifier,
                                               concernedBy: ["parameter1", 2, true]) as Void

        // Then
        XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
        let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }

    func test_resolveVoidThrowable_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: String.self)
        behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in 0 }]
        nextStrategy.resolveThrowableReturn = ()

        // When
        try? givenStrategy.resolveThrowable(for: functionIdentifier,
                                               concernedBy: ["parameter1", 2, true]) as Void

        // Then
        XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
        let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }

    func test_resolveVoidThrowable_shouldFailWithTooManyDefinedBehaviour() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: Void.self)
        let parameters: [ParameterType] = ["parameter1", 2, true]
        behaviourRegister.recordedBehavioursReturn = [FunctionBehaviour { _ in },
                                                      FunctionBehaviour { _ in }]
        errorHandler.handleReturn = ()

        // When
        try? givenStrategy.resolveThrowable(for: functionIdentifier, concernedBy: parameters) as Void

        // Then
        XCTAssertEqual(errorHandler.handleReceived[0],
                        .tooManyDefinedBehaviour(for: functionIdentifier, with: parameters))
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }

    func test_resolveVoidThrowable_shouldThrowErrorFromBehaviour() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: Void.self)
        let expectedError = NSError(domain: "domain", code: 0)
        let behaviour = FunctionBehaviour { _ in throw expectedError }
        behaviourRegister.recordedBehavioursReturn = [behaviour]

        // When
        var catchedError: NSError?
        do {
            _ = try givenStrategy.resolveThrowable(for: functionIdentifier,
                                                      concernedBy: ["parameter1", 2, true]) as Void
        } catch {
            catchedError = error as NSError
        }

        // Then
        XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
        let (identifier, parameters) = behaviourRegister.recordedBehavioursReceived.first!
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertTrue(catchedError === expectedError)
        XCTAssertEqual(behaviourRegister.makeBehaviourUsedReceived, [behaviour.identifier])
    }

    func test_resolveVoidThrowable_shouldThrowErroFromNextStrategy() {
        // Given
        let functionIdentifier = FunctionIdentifier.stub(returnType: Void.self)
        let expectedError = NSError(domain: "domain", code: 0)
        behaviourRegister.recordedBehavioursReturn = []
        nextStrategy.resolveThrowableError = expectedError

        // When
        var catchedError: NSError?
        do {
            _ = try givenStrategy.resolveThrowable(for: functionIdentifier,
                                                      concernedBy: ["parameter1", 2, true]) as Void
        } catch {
            catchedError = error as NSError
        }

        // Then
        XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
        let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
        XCTAssertEqual(identifier, functionIdentifier)
        XCTAssertEqual(parameters.count, 3)
        XCTAssertEqual(parameters[0] as? String, "parameter1")
        XCTAssertEqual(parameters[1] as? Int, 2)
        XCTAssertEqual(parameters[2] as? Bool, true)
        XCTAssertTrue(catchedError === expectedError)
        XCTAssertFalse(behaviourRegister.makeBehaviourUsedCalled)
    }
}
