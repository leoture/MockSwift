// GlobalStubStrategyTests.swift
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

private class Custom: GlobalStub {
  static func stub() -> Self {
    self.init("default")
  }

  let identifier: String
  required init(_ identifier: String) {
    self.identifier = identifier
  }
}

private struct AnyClass: Equatable {
  let uuid = UUID()
}

class GlobalStubStrategyTests: XCTestCase {
  private var globalStubStrategy: GlobalStubStrategy!
  private var nextStrategy: StrategyMock!

  override func setUp() {
    nextStrategy = StrategyMock()
    globalStubStrategy = GlobalStubStrategy(nextStrategy)
  }

  func test_resolve_shouldReturnStubCustom() {
    let result: Custom = globalStubStrategy.resolve(for: .stub(), concernedBy: [])
    XCTAssertEqual(result.identifier, "default")
  }

  func test_resolve_shouldReturnFromNextStrategy() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub()
    let expectedResult = AnyClass()
    nextStrategy.resolveReturn = expectedResult

    // When
    let result: AnyClass = globalStubStrategy.resolve(for: functionIdentifier,
                                                      concernedBy: ["1", 2])

    // Then
    XCTAssertEqual(nextStrategy.resolveReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 2)
    XCTAssertEqual(parameters[0] as? String, "1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(result, expectedResult)
  }

  func test_resolveThrowable_shouldReturnStubCustom() {
    let result = try? globalStubStrategy.resolveThrowable(for: .stub(), concernedBy: []) as Custom
    XCTAssertEqual(result?.identifier, "default")
  }

  func test_resolveThrowable_shouldReturnFromNextStrategy() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub()
    let expectedResult = AnyClass()
    nextStrategy.resolveThrowableReturn = expectedResult

    // When
    let result = try? globalStubStrategy.resolveThrowable(for: functionIdentifier,
                                                          concernedBy: ["1", 2]) as AnyClass

    // Then
    XCTAssertEqual(nextStrategy.resolveThrowableReceived.count, 1)
    let (identifier, parameters) = nextStrategy.resolveThrowableReceived[0]
    XCTAssertEqual(identifier, functionIdentifier)
    XCTAssertEqual(parameters.count, 2)
    XCTAssertEqual(parameters[0] as? String, "1")
    XCTAssertEqual(parameters[1] as? Int, 2)
    XCTAssertEqual(result, expectedResult)
  }

  func test_resolveThrowable_shouldThrowErroFromNextStrategy() {
    // Given
    let functionIdentifier = FunctionIdentifier.stub(returnType: AnyClass.self)
    let expectedError = NSError(domain: "domain", code: 0)
    nextStrategy.resolveThrowableError = expectedError

    // When
    var catchedError: NSError?
    do {
      _ = try globalStubStrategy.resolveThrowable(for: functionIdentifier,
                                                  concernedBy: ["parameter1", 2, true]) as AnyClass
    } catch {
      catchedError = error as NSError
    }

    // Then
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
