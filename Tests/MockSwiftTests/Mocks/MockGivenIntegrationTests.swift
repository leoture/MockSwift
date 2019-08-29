//MockGivenIntegrationTests.swift
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

extension MockGiven where WrappedType == Custom {
  func function(identifier: String) -> Mockable<Int> { mockable(identifier) }
  func function(identifier: Predicate<String>) -> Mockable<Int> { mockable(identifier) }

  func function(identifier: String) -> Mockable<String> { mockable(identifier) }
  func function(identifier: Predicate<String>) -> Mockable<String> { mockable(identifier) }
}

class MockGivenIntegrationTests: XCTestCase {
  @Mock private var custom: Custom

  func test_function_shouldReturnValueFromWillCompletion() {
    // Given
    given(_custom).function(identifier: .match { !$0.isEmpty })
      .disambiguate(with: String.self)
      .will { parameters in (parameters[0] as? String ?? "") + "1" }

    // When
    let result: String = custom.function(identifier: "value")

    //Then
    XCTAssertEqual(result, "value1")
  }

  func test_function_shouldReturnValueFromWillReturnValue() {
    // Given
    given(_custom).function(identifier: "value")
      .disambiguate(with: Int.self)
      .willReturn(42)

    // When
    let result: Int = custom.function(identifier: "value")

    //Then
    XCTAssertEqual(result, 42)
  }

  func test_function_shouldReturnDefaultValueIfNoMatch() {
    // Given
    given(_custom).function(identifier: .match { _ in false})
      .disambiguate(with: Int.self)
      .willReturn(42)

    // When
    let result: Int = custom.function(identifier: "value")

    //Then
    XCTAssertEqual(result, 0)
  }
}
