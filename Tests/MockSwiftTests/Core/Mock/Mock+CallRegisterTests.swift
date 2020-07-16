// Mock+CallRegisterTests.swift
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

private protocol AnyProtocol {}

final class MockCallRegisterTests: XCTestCase {
  private var mock: Mock<AnyProtocol>!
  private var callRegister: CallRegisterMock!

  override func setUp() {
    callRegister = CallRegisterMock()
    mock = Mock(callRegister: callRegister,
                behaviourRegister: BehaviourRegisterMock(),
                stubRegister: StubRegisterMock(),
                strategy: StrategyMock(),
                errorHandler: ErrorHandlerMock())
  }

  func test_recordCall_shouldCallRegister() {
    // Given
    let expectedIdentifier = FunctionIdentifier.stub()

    // When
    mock.recordCall(for: expectedIdentifier, with: ["1", 2])

    // Then
    XCTAssertEqual(callRegister.recordCallReceived.count, 1)
    let (identifier, parameters) = callRegister.recordCallReceived[0]
    XCTAssertEqual(identifier, expectedIdentifier)
    XCTAssertEqual(parameters.count, 2)
    XCTAssertEqual(parameters[0] as? String, "1")
    XCTAssertEqual(parameters[1] as? Int, 2)
  }

  func test_recordedCall_shouldReturnFromCallRegister() {
    // Given
    let expectedIdentifier = FunctionIdentifier.stub()
    let expectedResult = FunctionCall(identifier: UUID(), parameters: [1, 2], time: 0)
    callRegister.recordedCallsReturn = [expectedResult]

    // When
    let result = mock.recordedCalls(for: expectedIdentifier, when: ["1", 2])

    // Then
    XCTAssertEqual(callRegister.recordedCallsReceived.count, 1)
    let (identifier, parameters) = callRegister.recordedCallsReceived[0]
    XCTAssertEqual(identifier, expectedIdentifier)
    XCTAssertEqual(parameters.count, 2)
    XCTAssertEqual(parameters[0] as? String, "1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result[0].identifier, expectedResult.identifier)
    XCTAssertEqual(result[0].parameters as? [Int], [1, 2])
  }

  func test_allCallHaveBeenVerified_shouldReturnFromCallRegister() {
    // Given
    callRegister.allCallHaveBeenVerifiedReturn = true

    // When
    let result = mock.allCallHaveBeenVerified

    // Then
    XCTAssertEqual(callRegister.allCallHaveBeenVerifiedCallCount, 1)
    XCTAssertTrue(result)
  }

  func test_makeCallVerified_shouldReturnFromCallRegister() {
    // Given
    let expectedUUID = UUID()

    // When
    mock.makeCallVerified(for: expectedUUID)

    // Then
    XCTAssertEqual(callRegister.makeCallVerifiedReceived.count, 1)
    XCTAssertEqual(callRegister.makeCallVerifiedReceived[0], expectedUUID)
  }
}
