//DefaultFunctionBehaviourTests.swift
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

private class Custom: GlobalStub {
  static func stub() -> Self {
    self.init("default")
  }

  let identifier: String
  required init(_ identifier: String) {
    self.identifier = identifier
  }
}

private protocol AnyProtocol {}

class DefaultFunctionBehaviourTests: XCTestCase {
  private var defaultFunctionBehaviour: DefaultFunctionBehaviour!

  override func setUp() {
    defaultFunctionBehaviour = DefaultFunctionBehaviour()
  }

  func test_handle_shouldReturnStubCustom() {
    let custom: Custom? = defaultFunctionBehaviour.handle(with: [])
    XCTAssertEqual(custom?.identifier, "default")
  }

  func test_handle_shouldReturnNullOnUnknownType() {
    let result: AnyProtocol? = defaultFunctionBehaviour.handle(with: [])
    XCTAssertNil(result)
  }

  func test_handleThrowable_shouldReturnStubCustom() {
    let custom: Custom? = defaultFunctionBehaviour.handleThrowable(with: [])
    XCTAssertEqual(custom?.identifier, "default")
  }

  func test_handleThrowable_shouldReturnNullOnUnknownType() {
    let result: AnyProtocol? = defaultFunctionBehaviour.handleThrowable(with: [])
    XCTAssertNil(result)
  }
}
