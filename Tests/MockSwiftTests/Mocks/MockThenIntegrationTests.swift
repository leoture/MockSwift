//MockThenIntegrationTests.swift
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

private protocol Custom {
  func function(identifier: String) -> Int
  func function(identifier: String) -> String
}

extension Mock: Custom where WrappedType == Custom {
  func function(identifier: String) -> Int { mocked(identifier) }
  func function(identifier: String) -> String { mocked(identifier) }
}

extension MockThen where WrappedType == Custom {
  func function(identifier: String) -> Verifiable<Int> { verifiable(identifier) }
  func function(identifier: Predicate<String>) -> Verifiable<Int> { verifiable(identifier) }

  func function(identifier: String) -> Verifiable<String> { verifiable(identifier) }
  func function(identifier: Predicate<String>) -> Verifiable<String> { verifiable(identifier) }
}

class MockThenIntegrationTests: XCTestCase {
  @Mock private var custom: Custom

  func test_function_shouldBeCalledWhenParametersMatched() {
    // Given

    // When
    let _: String = custom.function(identifier: "value")
    let _: String = custom.function(identifier: "value")

    //Then
    then(_custom).function(identifier: .match { !$0.isEmpty })
      .disambiguate(with: String.self)
      .called(times: >1)
  }

  static var allTests = [
    ("test_function_shouldBeCalledWhenParametersMatched",
     test_function_shouldBeCalledWhenParametersMatched)
  ]
}
