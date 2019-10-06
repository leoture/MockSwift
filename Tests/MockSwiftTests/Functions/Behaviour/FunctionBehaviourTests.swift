//FunctionBehaviourTests.swift
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

class FunctionBehaviourTests: XCTestCase {

  func test_handle_shouldCallHandlerWithCorrectParameters() {
    // Given
    var capture: [ParameterType]?
    let behaviour = FunctionBehaviour { parameters in  capture = parameters}

    // When
    behaviour.handle(with: ["first", 1, true]) as Void?

    //Then
    XCTAssertEqual(capture?.count, 3)
    XCTAssertEqual(capture?[0] as? String, "first")
    XCTAssertEqual(capture?[1] as? Int, 1)
    XCTAssertEqual(capture?[2] as? Bool, true)
  }

  func test_handle_shouldReturnValueFormHandler() {
    // Given
    let uuid = UUID()
    let behaviour = FunctionBehaviour { _ in uuid }

    // When
    let value: UUID? = behaviour.handle(with: [])

    //Then
    XCTAssertEqual(value, uuid)
  }
}
