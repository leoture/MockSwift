// Mock+BehaviourRegisterTests.swift
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

private struct DummyBehaviour: Behaviour, Equatable {
  let uuid = UUID()

  func handle<ReturnType>(with parameters: [ParameterType]) -> ReturnType? { nil }

  func handleThrowable<ReturnType>(with parameters: [ParameterType]) throws -> ReturnType? { nil }
}

final class MockBehaviourRegisterTests: XCTestCase {
  private var mock: Mock<AnyProtocol>!
  private var behaviourRegister: BehaviourRegisterMock!

  override func setUp() {
    behaviourRegister = BehaviourRegisterMock()
    mock = Mock(callRegister: CallRegisterMock(),
                behaviourRegister: behaviourRegister,
                stubRegister: StubRegisterMock(),
                strategy: StrategyMock(),
                errorHandler: ErrorHandlerMock())
  }

  func test_record_shouldCallBehaviourRegister() {
    // Given
    let expectedBehaviour = DummyBehaviour()
    let expectedIdenfitier = FunctionIdentifier.stub()

    // When
    mock.record(expectedBehaviour, for: expectedIdenfitier, when: ["1", 2])

    // Then
    XCTAssertEqual(behaviourRegister.recordReceived.count, 1)
    let (behaviour, identifier, predicates) = behaviourRegister.recordReceived[0]
    XCTAssertEqual(behaviour as? DummyBehaviour, expectedBehaviour)
    XCTAssertEqual(identifier, expectedIdenfitier)
    XCTAssertEqual(predicates[0] as? String, "1")
    XCTAssertEqual(predicates[1] as? Int, 2)
  }

  func test_recordedCall_shouldReturnFromBehaviourRegister() {
    // Given
    let expectedBehaviour = DummyBehaviour()
    let expectedIdenfitier = FunctionIdentifier.stub()
    behaviourRegister.recordedBehavioursReturn = [expectedBehaviour]

    // When
    let result = mock.recordedBehaviours(for: expectedIdenfitier, concernedBy: ["1", 2])

    // Then
    XCTAssertEqual(behaviourRegister.recordedBehavioursReceived.count, 1)
    let (identifier, predicates) = behaviourRegister.recordedBehavioursReceived[0]
    XCTAssertEqual(identifier, expectedIdenfitier)
    XCTAssertEqual(predicates[0] as? String, "1")
    XCTAssertEqual(predicates[1] as? Int, 2)
    XCTAssertEqual(result.count, 1)
    XCTAssertEqual(result[0] as? DummyBehaviour, expectedBehaviour)
  }
}
