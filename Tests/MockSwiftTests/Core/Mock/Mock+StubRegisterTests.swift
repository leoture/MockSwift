//Mock+StubRegisterTests.swift
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

class MockStubRegisterTests: XCTestCase {
  private var mock: Mock<AnyProtocol>!
  private var stubRegister: StubRegisterMock!

  override func setUp() {
    stubRegister = StubRegisterMock()
    mock = Mock(callRegister: CallRegisterMock(),
                behaviourRegister: BehaviourRegisterMock(),
                stubRegister: stubRegister,
                strategy: StrategyMock(),
                errorHandler: ErrorHandlerMock())
  }

  func test_recordedStub_shouldCallStubRegister() {
    // Given
    stubRegister.recordedStubReturn = "result"

    // When
    let result = mock.recordedStub(for: String.self)

    //Then
    XCTAssertEqual(stubRegister.recordedStubReceived.count, 1)
    let value = stubRegister.recordedStubReceived[0] as? String.Type
    XCTAssertTrue(value == String.self)
    XCTAssertEqual(result, "result")
  }

  func test_recordedCall_shouldReturnFromBehaviourRegister() {
    // Given

    // When
    mock.record(Stub(String.self, "value"))

    //Then
    XCTAssertEqual(stubRegister.recordReceived.count, 1)
    let stub = stubRegister.recordReceived[0]
    XCTAssertNotNil(stub.returnType as? String.Type)
    XCTAssertEqual(stub.value as? String, "value")
  }
}
