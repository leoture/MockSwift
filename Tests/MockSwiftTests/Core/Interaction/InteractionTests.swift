// InteractionTests.swift
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

class InteractionTests: XCTestCase {
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

  func test_interaction_whenTypeIsAMockShouldPass() {
    let _: Interaction<Custom> = interaction(customMock,
                                             errorHandler: errorHandler,
                                             failureRecorder: failureRecorder)
  }

  func test_Interaction_whenTypeIsNotAMockShouldFailWithCast() {
    // Given
    let customImpl = CustomImpl()
    let interactionCustom: Interaction<Custom> = interaction(with: customMock)
    errorHandler.handleReturn = interactionCustom

    // When
    let result: Interaction<Custom> = interaction(customImpl,
                                                  errorHandler: errorHandler,
                                                  failureRecorder: failureRecorder)

    // Then
    XCTAssertTrue(result === interactionCustom)
    XCTAssertEqual(errorHandler.handleReceived[0], .cast(source: customImpl, target: Mock<Custom>.self))
  }

  func test_ended_whenAllCallHaveNotBeenVerifiedShouldCorrectlyCallFailureRecorder() {
    // Given
    callRegister.allCallHaveBeenVerifiedReturn = false

    // When
    Interaction<Custom>(callRegister: callRegister, failureRecorder: failureRecorder)
      .ended(file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.allCallHaveBeenVerifiedCallCount, 1)
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 1)
    let (message, file, line) = failureRecorder.recordFailureReceived[0]
    XCTAssertEqual(message, "Custom expects to have no more interactions to check.")
    XCTAssertEqual("\(file) \(line)", "file 42")
  }

  func test_ended_whenAllCallHaveBeenVerifiedShouldNotCallFailureRecorder() {
    // Given
    callRegister.allCallHaveBeenVerifiedReturn = true

    // When
    Interaction<Custom>(callRegister: callRegister, failureRecorder: failureRecorder)
      .ended(file: "file", line: 42)

    // Then
    XCTAssertEqual(callRegister.allCallHaveBeenVerifiedCallCount, 1)
    XCTAssertEqual(failureRecorder.recordFailureReceived.count, 0)
  }
}
