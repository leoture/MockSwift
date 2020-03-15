// FunctionBehaviourTests.swift
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

class FunctionBehaviourTests: XCTestCase {
  func test_handle_shouldCallHandlerWithCorrectParameters() {
    // Given
    var capture: [ParameterType]?
    let behaviour = FunctionBehaviour { parameters in capture = parameters }

    // When
    behaviour.handle(with: ["first", 1, true]) as Void?

    // Then
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

    // Then
    XCTAssertEqual(value, uuid)
  }

  func test_handle_shouldReturnNilIfNotSameType() {
    // Given
    let behaviour = FunctionBehaviour { _ in "" }

    // When
    let value: UUID? = behaviour.handle(with: [])

    // Then
    XCTAssertNil(value)
  }

  func test_handle_shouldReturnNilIfHandlerThrows() {
    // Given
    let behaviour = FunctionBehaviour { _ in throw NSError(domain: "domain", code: 0) }

    // When
    let value: UUID? = behaviour.handle(with: [])

    // Then
    XCTAssertNil(value)
  }

  func test_handleThrowable_shouldCallHandlerWithCorrectParameters() {
    // Given
    var capture: [ParameterType]?
    let behaviour = FunctionBehaviour { parameters in capture = parameters }

    // When
    try? behaviour.handleThrowable(with: ["first", 1, true]) as Void?

    // Then
    XCTAssertEqual(capture?.count, 3)
    XCTAssertEqual(capture?[0] as? String, "first")
    XCTAssertEqual(capture?[1] as? Int, 1)
    XCTAssertEqual(capture?[2] as? Bool, true)
  }

  func test_handleThrowable_shouldReturnValueFormHandler() {
    // Given
    let uuid = UUID()
    let behaviour = FunctionBehaviour { _ in uuid }

    // When
    let value: UUID? = try? behaviour.handleThrowable(with: [])

    // Then
    XCTAssertEqual(value, uuid)
  }

  func test_handleThrowable_shouldReturnNilIfNotSameType() {
    // Given
    let behaviour = FunctionBehaviour { _ in "" }

    // When
    var value: UUID?
    do {
      value = try behaviour.handleThrowable(with: [])
    } catch {
      XCTFail("handleThrowable should not throws")
    }

    // Then
    XCTAssertNil(value)
  }

  func test_handleThrowable_shouldThrowsIfHandlerThrows() {
    // Given
    let expectedError = NSError(domain: "domain", code: 0)
    let behaviour = FunctionBehaviour { _ in throw expectedError }

    // When
    var catchedError: NSError?
    var value: UUID?
    do {
      value = try behaviour.handleThrowable(with: [])
    } catch {
      catchedError = error as NSError
    }

    // Then
    XCTAssertNil(value)
    XCTAssertTrue(expectedError === catchedError!)
  }
}
