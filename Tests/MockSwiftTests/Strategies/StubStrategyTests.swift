//StubStrategyTests.swift
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

final class StubStrategyTests: XCTestCase {
  private var stubStrategy: StubStrategy!
  private var nextStrategy: StrategyMock!
  private var stubRegister: StubRegisterMock!

  override func setUp() {
    stubRegister = StubRegisterMock()
    nextStrategy = StrategyMock()
    stubStrategy = StubStrategy(next: nextStrategy,
                                stubRegister: stubRegister)
  }

  func test_resolve_shouldReturnFromNextStrategyWhenNoStubFound() {
    // Given
    let uuid = UUID()
    let functionIdentifier = FunctionIdentifier.stub(returnType: UUID.self)
    stubRegister.recordedStubReturn = nil
    nextStrategy.resolveReturn = uuid

    // When
    let result: UUID = stubStrategy.resolve(for: functionIdentifier,
                                            concernedBy: ["parameter1", 2, true])

    //Then
    XCTAssertEqual(nextStrategy.resolveReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(result, uuid)
  }

  func test_resolve_shouldReturnValueFromRegister() {
    // Given
    let uuid = UUID()
    stubRegister.recordedStubReturn = uuid

    // When
    let result: UUID = stubStrategy.resolve(for: .stub(), concernedBy: [])

    //Then
    XCTAssertEqual(result, uuid)
  }

  func test_resolveThrowable_shouldReturnFromNextStrategyWhenNoStubFound() {
    // Given
    let uuid = UUID()
    let functionIdentifier = FunctionIdentifier.stub(returnType: UUID.self)
    stubRegister.recordedStubReturn = nil
    nextStrategy.resolveThrowableReturn = uuid

    // When
    let result = try? stubStrategy.resolveThrowable(for: functionIdentifier,
                                                    concernedBy: ["parameter1", 2, true]) as UUID

    //Then
    XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertEqual(result, uuid)
  }

  func test_resolveThrowable_shouldReturnValueFromRegister() {
    // Given
    let uuid = UUID()
    stubRegister.recordedStubReturn = uuid

    // When
    let result = try? stubStrategy.resolveThrowable(for: .stub(), concernedBy: []) as UUID

    //Then
    XCTAssertEqual(result, uuid)
  }

  func test_resolveThrowable_shouldThrowErroFromNextStrategy() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: UUID.self)
    let expectedError = NSError(domain: "domain", code: 0)
    nextStrategy.resolveThrowableError = expectedError

    // When
    var catchedError: NSError?
    do {
      _ = try stubStrategy.resolveThrowable(for: functionIdentifier,
                                            concernedBy: ["parameter1", 2, true]) as UUID
    } catch {
      catchedError = error as NSError
    }

    //Then
    XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 3)
    XCTAssertEqual(parameters[0] as? String, "parameter1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(parameters[2] as? Bool, true)
    XCTAssertTrue(catchedError === expectedError)
  }

}
