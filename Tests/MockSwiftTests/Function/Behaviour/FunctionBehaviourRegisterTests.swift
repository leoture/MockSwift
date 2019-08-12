//FunctionBehaviourRegisterTests.swift
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

class FunctionBehaviourRegisterTests: XCTestCase {
  private var functionBehaviourRegister: FunctionBehaviourRegister!

  override func setUp() {
    functionBehaviourRegister = FunctionBehaviourRegister()
  }

  func test_recordedBehaviours_shouldReturnDefaultFunctionBehaviourWhenNoMatchs() {
    // Given
    let predicate = AnyPredicateMock()
    predicate.satisfyReturn = false
    functionBehaviourRegister.record(FunctionBehaviour(handler: {_ in }), for: .stub(), when: [predicate])

    // When
    let behaviours = functionBehaviourRegister.recordedBehaviours(for: .stub(), concernedBy: [true])

    //Then
    XCTAssertEqual(behaviours.count, 1)
    XCTAssertTrue(behaviours[0] is DefaultFunctionBehaviour)
  }

  func test_recordedBehaviours_shouldReturnFunctionBehaviourMatched() {
    // Given
    let predicateTrue = AnyPredicateMock()
    predicateTrue.satisfyReturn = true
    let predicateFalse = AnyPredicateMock()
    predicateFalse.satisfyReturn = false
    let firstHandlerReturn = UUID()
    let secondHandlerReturn = UUID()
    functionBehaviourRegister.record(FunctionBehaviour(handler: {_ in firstHandlerReturn}),
                                     for: .stub(),
                                     when: [predicateTrue])
    functionBehaviourRegister.record(FunctionBehaviour(handler: {_ in secondHandlerReturn}),
                                     for: .stub(),
                                     when: [predicateTrue])
    functionBehaviourRegister.record(FunctionBehaviour(handler: {_ in }),
                                     for: .stub(),
                                     when: [predicateFalse])

    // When
    let behaviours = functionBehaviourRegister.recordedBehaviours(for: .stub(), concernedBy: [true])

    //Then
    XCTAssertEqual(behaviours.count, 2)
    XCTAssertEqual(behaviours[0].handle(with: []), firstHandlerReturn)
    XCTAssertEqual(behaviours[1].handle(with: []), secondHandlerReturn)
  }

  static var allTests = [
    ("test_recordedBehaviours_shouldReturnDefaultFunctionBehaviourWhenNoMatchs",
     test_recordedBehaviours_shouldReturnDefaultFunctionBehaviourWhenNoMatchs),

    ("test_recordedBehaviours_shouldReturnFunctionBehaviourMatched",
    test_recordedBehaviours_shouldReturnFunctionBehaviourMatched)
  ]
}
