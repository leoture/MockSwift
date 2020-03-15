// MockStrategyFactoryTests.swift
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

class MockStrategyFactoryTests: XCTestCase {
  private var factory: MockStrategyFactory!
  private var errorHandler: ErrorHandlerMock!
  private var behaviourRegister: BehaviourRegisterMock!
  private var stubRegister: StubRegisterMock!

  override func setUp() {
    errorHandler = ErrorHandlerMock()
    behaviourRegister = BehaviourRegisterMock()
    stubRegister = StubRegisterMock()
    factory = MockStrategyFactory(errorHandler: errorHandler,
                                  behaviourRegister: behaviourRegister,
                                  stubRegister: stubRegister)
  }

  func test_create_shouldReturnUnresolvedStrategyWhenEmpty() {
    // Given

    // When
    let strategy = factory.create(strategy: [])

    // Then
    let unresolvedStrategy = strategy as? UnresolvedStrategy
    XCTAssertNotNil(unresolvedStrategy)
    XCTAssertTrue(unresolvedStrategy!.errorHandler === errorHandler)
  }

  func test_create_shouldReturnCorrectStrategyChain() {
    // Given

    // When
    let strategy = factory.create(strategy: [.globalStubs, .localStubs, .given])

    // Then
    let globalStubStrategy = strategy as? GlobalStubStrategy
    XCTAssertNotNil(globalStubStrategy)

    let localStubStrategy = globalStubStrategy?.strategy as? StubStrategy
    let stubRegisterMock = localStubStrategy!.stubRegister as? StubRegisterMock
    XCTAssertTrue(stubRegisterMock === stubRegister)

    let givenStrategy = localStubStrategy?.strategy as? GivenStrategy
    let behaviourRegisterMock = givenStrategy!.behaviourRegister as? BehaviourRegisterMock
    XCTAssertTrue(behaviourRegisterMock === behaviourRegister)
    XCTAssertTrue(givenStrategy!.errorHandler === errorHandler)

    let unresolvedStrategy = givenStrategy?.strategy as? UnresolvedStrategy
    XCTAssertTrue(unresolvedStrategy!.errorHandler === errorHandler)
  }

  func test_create_shouldReturnCorrectStrategyChainWhenDefault() {
    // Given

    // When
    let strategy = factory.create(strategy: .default)

    // Then
    let givenStrategy = strategy as? GivenStrategy
    let behaviourRegisterMock = givenStrategy?.behaviourRegister as? BehaviourRegisterMock
    XCTAssertTrue(behaviourRegisterMock === behaviourRegister)
    XCTAssertTrue(givenStrategy!.errorHandler === errorHandler)

    let localStubStrategy = givenStrategy?.strategy as? StubStrategy
    let stubRegisterMock = localStubStrategy?.stubRegister as? StubRegisterMock
    XCTAssertTrue(stubRegisterMock === stubRegister)

    let globalStubStrategy = localStubStrategy?.strategy as? GlobalStubStrategy
    XCTAssertNotNil(globalStubStrategy)

    let unresolvedStrategy = globalStubStrategy?.strategy as? UnresolvedStrategy
    XCTAssertTrue(unresolvedStrategy!.errorHandler === errorHandler)
  }
}
