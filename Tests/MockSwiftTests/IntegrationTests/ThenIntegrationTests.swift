// ThenIntegrationTests.swift
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

import MockSwift
import XCTest

private protocol Custom {
  var identifier: String { get set }
  var computed: String { get }
  subscript(first: Int, second: String) -> String { get }
  subscript(x first: Int, y second: Int) -> String { get set }
  func function(identifier: String) -> Int
  func function(identifier: String) -> String
}

extension Mock: Custom where WrappedType == Custom {
  var identifier: String {
    get { mocked() }
    set { mocked(newValue) }
  }

  var computed: String {
    mocked()
  }

  subscript(first: Int, second: String) -> String {
    mocked(first, second)
  }

  subscript(x first: Int, y second: Int) -> String {
    get {
      mocked(first, second)
    }
    set {
      mocked(first, second, newValue)
    }
  }

  func function(identifier: String) -> Int { mocked(identifier) }
  func function(identifier: String) -> String { mocked(identifier) }
}

extension Then where WrappedType == Custom {
  var identifier: VerifiableProperty.Writable<String> { verifiable() }

  var computed: VerifiableProperty.Readable<String> { verifiable() }

  subscript(first: Predicate<Int>, second: Predicate<String>) -> VerifiableSubscript.Readable<String> {
    verifiable(first, second)
  }

  subscript(x first: Int, y second: Int) -> VerifiableSubscript.Writable<String> {
    verifiable(first, second)
  }

  func function(identifier: String) -> Verifiable<Int> { verifiable(identifier) }
  func function(identifier: Predicate<String>) -> Verifiable<Int> { verifiable(identifier) }

  func function(identifier: String) -> Verifiable<String> { verifiable(identifier) }
  func function(identifier: Predicate<String>) -> Verifiable<String> { verifiable(identifier) }
}

class ThenIntegrationTests: XCTestCase {
  @Mock private var custom: Custom

  func test_function_shouldBeCalledWhenParametersMatched() {
    // Given

    // When
    let _: String = custom.function(identifier: "value")
    let _: String = custom.function(identifier: "value")

    // Then
    then(custom).function(identifier: .match { !$0.isEmpty })
      .disambiguate(with: String.self)
      .called(times: >1)
  }

  func test_then_shouldCallCompletionWithThenCustom() {
    // Given
    var thenCustom: Then<Custom>?

    // When
    then(custom) { thenCustom = $0 }

    // Then
    XCTAssertNotNil(thenCustom)
  }

  func test_receivedParameters_whenParametersMatched() {
    // Given

    // When
    let _: String = custom.function(identifier: "arg1")
    let _: String = custom.function(identifier: "")
    let _: String = custom.function(identifier: "arg2")

    // Then
    let receivedParameters = then(custom).function(identifier: .not(.match(when: \.isEmpty)))
      .disambiguate(with: String.self)
      .receivedParameters
    XCTAssertEqual(receivedParameters as? [[String]], [["arg1"], ["arg2"]])
  }

  func test_callCount_whenParametersMatched() {
    // Given

    // When
    let _: String = custom.function(identifier: "arg1")
    let _: String = custom.function(identifier: "")
    let _: String = custom.function(identifier: "arg2")

    // Then
    let callCount = then(custom).function(identifier: .not(.match(when: \.isEmpty)))
      .disambiguate(with: String.self)
      .callCount
    XCTAssertEqual(callCount, 2)
  }

  func test_Readable_get_shouldBeCalled() {
    // Given

    // When
    _ = custom.computed
    _ = custom.computed

    // Then
    then(custom).computed.get.called(times: 2)
  }

  func test_Writable_get_shouldBeCalled() {
    // Given

    // When
    _ = custom.identifier
    _ = custom.identifier

    // Then
    then(custom).identifier.get.called(times: 2)
  }

  func test_Writable_set_shouldBeCalledWhenParametersMatched() {
    // Given
    let custom = Mock<Custom>()

    // When
    custom.identifier = "value"

    // Then
    then(custom).identifier.set(.not(.match(when: \.isEmpty))).called()
    then(custom).identifier.set("value").called()
  }

  func test_Writable_set_shouldNotBeCalledWhenParametersDontMatch() {
    // Given
    let custom = Mock<Custom>()

    // When
    custom.identifier = "value"

    // Then
    then(custom).identifier.set(.match(when: \.isEmpty)).called(times: 0)
  }

  func test_subscriptFirstSecond_get_shouldBeCalled() {
    // Given

    // When
    _ = custom[1, "a"]
    _ = custom[1, "b"]

    // Then
    then(custom)[==1, .match { $0 == "a" || $0 == "b" }].get.called(times: 2)
  }

  func test_subscriptXY_get_shouldBeCalled() {
    // Given

    // When
    _ = custom[x: 1, y: 2]

    // Then
    then(custom)[x: 1, y: 2].get.called(times: 1)
  }

  func test_subscriptXY_set_shouldBeCalledWhenParametersMatched() {
    // Given
    let custom = Mock<Custom>()

    // When
    custom[x: 1, y: 2] = "value"

    // Then
    then(custom)[x: 1, y: 2].set(.not(.match(when: \.isEmpty))).called()
    then(custom)[x: 1, y: 2].set("value").called()
  }

  func test_subscriptXY_set_shouldNotBeCalledWhenParametersDontMatch() {
    // Given
    let custom = Mock<Custom>()

    // When
    custom[x: 1, y: 2] = "value"

    // Then
    then(custom)[x: 1, y: 2].set(.match(when: \.isEmpty)).called(times: 0)
  }

  func test_noInteraction_whenNoInteractionWithMockShouldSucceed() {
    then(custom).noInteraction()
  }
}
