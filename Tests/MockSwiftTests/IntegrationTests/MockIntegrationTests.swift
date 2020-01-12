//MockIntegrationTests.swift
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
import MockSwift

private struct AnyClass {
  let identifier: String
}

private protocol Custom {
  var computed: String { get }
  func function(identifier: String) -> Int
  func functionStub() -> AnyClass
}

extension Mock: Custom where WrappedType == Custom {
  var computed: String {
    mocked()
  }
  func function(identifier: String) -> Int { mocked(identifier) }

  func functionStub() -> AnyClass { mocked() }
}

extension MockGiven where WrappedType == Custom {
  var computed: MockableProperty.Readable<String> { mockable() }

  func function(identifier: String) -> Mockable<Int> { mockable(identifier) }
}

class MockIntegrationTests: XCTestCase {
  @Mock(stubs: [
    AnyClass.self => AnyClass(identifier: "stub")
    ], {
      $0.computed.get.willReturn("id")
      $0.function(identifier: "id").willReturn(3)
  }) private var custom: Custom

  func test_computed_get_shouldReturnFromMockInit() {
    let computed = custom.computed
    XCTAssertEqual(computed, "id")
  }

  func test_function_shouldReturnValueFromMockInit() {
    let result = custom.function(identifier: "id")
    XCTAssertEqual(result, 3)
  }

  func test_functionStub_shouldReturnValueFromStub() {
    let result = custom.functionStub()
    XCTAssertEqual(result.identifier, "stub")
  }
}
