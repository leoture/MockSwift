// UnresolvedStrategyTests.swift
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

class UnresolvedStrategyTests: XCTestCase {
  private var strategy: UnresolvedStrategy!
  private var errorHandler: ErrorHandlerMock!

  override func setUp() {
    errorHandler = ErrorHandlerMock()
    strategy = UnresolvedStrategy(errorHandler)
  }

  func test_resolve_shouldReturnFromErrorHandler() {
    // Given
    let identifier = FunctionIdentifier.stub(returnType: String.self)
    let parameters: [ParameterType] = ["1", 2]
    errorHandler.handleReturn = "error"

    // When
    let result: String = strategy.resolve(for: identifier, concernedBy: parameters)

    // Then
    XCTAssertEqual(errorHandler.handleReceived.count, 1)
    XCTAssertEqual(errorHandler.handleReceived[0], .noDefinedBehaviour(for: identifier, with: parameters))
    XCTAssertEqual(result, "error")
  }

  func test_resolveThrowable_shouldReturnFromErrorHandler() {
    // Given
    let identifier = FunctionIdentifier.stub(returnType: String.self)
    let parameters: [ParameterType] = ["1", 2]
    errorHandler.handleReturn = "error"

    // When
    let result: String? = try? strategy.resolveThrowable(for: identifier, concernedBy: parameters)

    // Then
    XCTAssertEqual(errorHandler.handleReceived.count, 1)
    XCTAssertEqual(errorHandler.handleReceived[0], .noDefinedBehaviour(for: identifier, with: parameters))
    XCTAssertEqual(result, "error")
  }
}
