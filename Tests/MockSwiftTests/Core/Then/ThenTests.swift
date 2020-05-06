// ThenTests.swift
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

import Foundation
@testable import MockSwift
import XCTest

private protocol Custom {}

private class CustomImpl: Custom {}
extension Mock: Custom where WrappedType == Custom {}

class ThenTests: XCTestCase {
  private var customMock: Mock<Custom>!
  private var errorHandler: ErrorHandlerMock!
  private var callRegister: CallRegisterMock!
  private var failureRecorder: FailureRecorderMock!

  override func setUp() {
    errorHandler = ErrorHandlerMock()
    failureRecorder = FailureRecorderMock()
    callRegister = CallRegisterMock()
    customMock = Mock(callRegister: callRegister,
                      behaviourRegister: BehaviourRegisterMock(),
                      stubRegister: StubRegisterMock(),
                      strategy: UnresolvedStrategy(errorHandler),
                      errorHandler: errorHandler)
  }
  func test_then_shouldPass() {
    let _: Then<Custom> = then(customMock)
  }

  func test_thenCompletion_shouldPass() {
    then(customMock) { (_: Then<Custom>) in }
  }

  func test_then_whenTypeIsNotAMockShouldFailWithCast() {
    // Given
    let customImpl = CustomImpl()
    let thenCustom: Then<Custom> = then(customMock)
    errorHandler.handleReturn = thenCustom

    // When
    let result: Then<Custom> = then(customImpl,
                                    errorHandler: errorHandler,
                                    failureRecorder: failureRecorder,
                                    file: "file",
                                    line: 42)

    // Then
    XCTAssertTrue(result === thenCustom)
    XCTAssertEqual(errorHandler.handleReceived[0], .cast(source: customImpl, target: Mock<Custom>.self))
  }

  func test_noInteraction_whenWhenCallRegisterIsEmptyShouldCorrectlyCallFailureRecorder() {
    // Given
    let thenCustom: Then<Custom> = then(customMock)
    errorHandler.handleReturn = thenCustom
    callRegister.isEmptyReturn = false

    // When
    let result: Then<Custom> = then(customMock,
                                    errorHandler: errorHandler,
                                    failureRecorder: failureRecorder,
                                    file: "",
                                    line: 0)
    result.noInteraction(file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.isEmptyCallCount, 1)
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "Custom expect to have no interaction.")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_noInteraction_whenWhenCallRegisterIsNotEmptyShouldNotCallFailureRecorder() {
    // Given
    let thenCustom: Then<Custom> = then(customMock)
    errorHandler.handleReturn = thenCustom
    callRegister.isEmptyReturn = true

    // When
    let result: Then<Custom> = then(customMock,
                                    errorHandler: errorHandler,
                                    failureRecorder: failureRecorder,
                                    file: "",
                                    line: 0)
    result.noInteraction(file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.isEmptyCallCount, 1)
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }
}
