// FunctionBehaviourRegisterTests.swift
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

class FunctionBehaviourRegisterTests: XCTestCase {
  private var functionBehaviourRegister: FunctionBehaviourRegister!

  override func setUp() {
    functionBehaviourRegister = FunctionBehaviourRegister()
  }

  func test_recordedBehaviours_shouldReturnEmptyWhenNoMatchs() {
    // Given
    let predicate = AnyPredicateMock()
    predicate.satisfyReturn = false
    functionBehaviourRegister.record(BehaviourTrigger(predicates: [predicate],
                                                      behaviour: FunctionBehaviour()),
                                     for: .stub())

    // When
    let behaviours = functionBehaviourRegister.recordedBehaviours(for: .stub(), concernedBy: [true])

    // Then
    XCTAssertTrue(behaviours.isEmpty)
  }

  func test_recordedBehaviours_shouldReturnFunctionBehaviourMatched() {
    // Given
    let predicateTrue = AnyPredicateMock()
    predicateTrue.satisfyReturn = true

    let predicateFalse = AnyPredicateMock()
    predicateFalse.satisfyReturn = false

    let firstHandlerReturn = UUID()
    let secondHandlerReturn = UUID()

    functionBehaviourRegister.record(BehaviourTrigger(predicates: [predicateTrue],
                                                      behaviour: FunctionBehaviour(handler: { _ in
        firstHandlerReturn
    })),
                                     for: .stub())

    functionBehaviourRegister.record(BehaviourTrigger(predicates: [predicateTrue],
                                                      behaviour: FunctionBehaviour(handler: { _ in
        secondHandlerReturn
    })),
                                     for: .stub())

    functionBehaviourRegister.record(BehaviourTrigger(predicates: [predicateFalse],
                                                      behaviour: FunctionBehaviour()),
                                     for: .stub())

    // When
    let behaviours = functionBehaviourRegister.recordedBehaviours(for: .stub(), concernedBy: [true])

    // Then
    XCTAssertEqual(behaviours.count, 2)
    XCTAssertEqual(behaviours[0].handle(with: []), firstHandlerReturn)
    XCTAssertEqual(behaviours[1].handle(with: []), secondHandlerReturn)
  }

    func test_unusedFunctionBehaviours_whenSomeBehavioursHaveNotBeenUsed() {
        // Given
        let usedBehaviour = FunctionBehaviour()
        let unusedBehaviour = FunctionBehaviour()
        let unusedBehaviourIdentifier = FunctionIdentifier(function: "unused", return: Int.self)
        functionBehaviourRegister.record(BehaviourTrigger(predicates: [],
                                                          behaviour: unusedBehaviour),
                                         for: unusedBehaviourIdentifier)
        functionBehaviourRegister.record(BehaviourTrigger(predicates: [],
                                                          behaviour: usedBehaviour),
                                         for: .stub())
        functionBehaviourRegister.makeBehaviourUsed(for: usedBehaviour.identifier)

        // When
        let result = functionBehaviourRegister.unusedFunctionBehaviours

        // Then
        XCTAssertEqual(result.count, 1)
        let value = result[unusedBehaviourIdentifier]!
        XCTAssertEqual(value.count, 1)
        let recorded = value[0]
        XCTAssertEqual(unusedBehaviour.identifier, recorded.behaviour.identifier)
    }

    func test_unusedFunctionBehaviours_whenAllBehavioursHaveBeenUsed() {
        // Given
        let usedBehaviour = FunctionBehaviour()
        functionBehaviourRegister.record(BehaviourTrigger(predicates: [],
                                                          behaviour: usedBehaviour),
                                         for: .stub())
        functionBehaviourRegister.makeBehaviourUsed(for: usedBehaviour.identifier)

        // When
        let result = functionBehaviourRegister.unusedFunctionBehaviours

        // Then
        XCTAssertTrue(result.isEmpty, "unusedFunctionBehaviours should be empty when all behaviours have been used")
    }
}
