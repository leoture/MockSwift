// MockableTests.swift
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

class MockableTests: XCTestCase {
  func test_willReturn_shouldCorrectlyRegisterBahaviour() {
    // Given
    let behaviourRegister = BehaviourRegisterMock()
    let identifier = FunctionIdentifier.stub()
    let predicate = AnyPredicateMock()
    let mockable: Mockable<UUID> = Mockable(behaviourRegister, identifier, [predicate])
    let expectedBehaviourReturn = UUID()

    // When
    mockable.willReturn(expectedBehaviourReturn)

    // Then
    XCTAssertEqual(behaviourRegister.recordReceived.count, 1)
    let parameters = behaviourRegister.recordReceived[0]
    XCTAssertEqual(parameters.behaviour.handle(with: []), expectedBehaviourReturn)
    XCTAssertEqual(parameters.identifier, identifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue((parameters.matchs[0] as? AnyPredicateMock) === predicate)
  }

  func test_willReturn_withListShouldCorrectlyRegisterBahaviour() {
    // Given
    let behaviourRegister = BehaviourRegisterMock()
    let identifier = FunctionIdentifier.stub()
    let predicate = AnyPredicateMock()
    let mockable: Mockable<UUID> = Mockable(behaviourRegister, identifier, [predicate])
    let expectedFirstBehaviourReturn = UUID()
    let expectedSecondBehaviourReturn = UUID()

    // When
    mockable.willReturn(expectedFirstBehaviourReturn, expectedSecondBehaviourReturn)

    // Then
    XCTAssertEqual(behaviourRegister.recordReceived.count, 1)
    let parameters = behaviourRegister.recordReceived[0]
    XCTAssertEqual(parameters.behaviour.handle(with: []), expectedFirstBehaviourReturn)
    XCTAssertEqual(parameters.behaviour.handle(with: []), expectedSecondBehaviourReturn)
    XCTAssertEqual(parameters.behaviour.handle(with: []), expectedSecondBehaviourReturn)
    XCTAssertEqual(parameters.identifier, identifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue((parameters.matchs[0] as? AnyPredicateMock) === predicate)
  }

  func test_will_shouldCorrectlyRegisterBahaviour() {
    // Given
    let behaviourRegister = BehaviourRegisterMock()
    let identifier = FunctionIdentifier.stub()
    let predicate = AnyPredicateMock()
    let mockable: Mockable<UUID> = Mockable(behaviourRegister, identifier, [predicate])
    var behaviourReceived: [UUID]?
    let expectedBehaviourReturn = UUID()

    // When
    mockable.will {
      behaviourReceived = $0 as? [UUID]
      return expectedBehaviourReturn
    }

    // Then
    XCTAssertEqual(behaviourRegister.recordReceived.count, 1)
    let parameters = behaviourRegister.recordReceived[0]
    let expectedBehaviourReceived = [UUID()]
    let behaviourResult: UUID? = parameters.behaviour.handle(with: expectedBehaviourReceived)
    XCTAssertEqual(behaviourReceived, expectedBehaviourReceived)
    XCTAssertEqual(behaviourResult, expectedBehaviourReturn)
    XCTAssertEqual(parameters.identifier, identifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue((parameters.matchs[0] as? AnyPredicateMock) === predicate)
  }

  func test_disambiguate_shouldReturnSameMockableWithDisambiguatedReturnType() {
    // Given
    let mockable = Mockable(BehaviourRegisterMock(), .stub(), []).disambiguate(with: String.self)

    // When
    let disambiguatedMockable: Mockable<String> = mockable.disambiguate(with: String.self)

    // Then
    XCTAssertTrue(disambiguatedMockable === mockable)
  }

  func test_willThrow_shouldCorrectlyRegisterBahaviour() {
    // Given
    let behaviourRegister = BehaviourRegisterMock()
    let identifier = FunctionIdentifier.stub()
    let predicate = AnyPredicateMock()
    let mockable: Mockable<UUID> = Mockable(behaviourRegister, identifier, [predicate])
    let expectedBehaviourError = NSError(domain: "domain", code: 0)

    // When
    mockable.willThrow(expectedBehaviourError)

    // Then
    XCTAssertEqual(behaviourRegister.recordReceived.count, 1)
    let parameters = behaviourRegister.recordReceived[0]
    XCTAssertEqual(parameters.identifier, identifier)
    XCTAssertEqual(parameters.matchs.count, 1)
    XCTAssertTrue((parameters.matchs[0] as? AnyPredicateMock) === predicate)

    var catchedError: NSError?
    do {
      let _: UUID? = try parameters.behaviour.handleThrowable(with: [])
    } catch {
      catchedError = error as NSError
    }
    XCTAssertTrue(catchedError === expectedBehaviourError)
  }
}
