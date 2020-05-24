// InteractionIntegrationTests.swift
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
  func doSomething()
  var read: String { get }
  var write: String { get set }
  subscript(first: Int, second: String) -> String { get }
  subscript(x first: Int, y second: Int) -> String { get set }
}

extension Mock: Custom where WrappedType == Custom {
  func doSomething() {
    mocked()
  }

  var write: String {
    get { mocked() }
    set { mocked(newValue) }
  }

  var read: String {
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
}

extension Then where WrappedType == Custom {
  func doSomething() -> Verifiable<Void> {
    verifiable()
  }

  var write: VerifiableProperty.Writable<String> {
    verifiable()
  }

  var read: VerifiableProperty.Readable<String> {
    verifiable()
  }

  subscript(first: Int, second: String) -> VerifiableSubscript.Readable<String> {
    verifiable(first, second)
  }

  subscript(x first: Int, y second: Int) -> VerifiableSubscript.Writable<String> {
    verifiable(first, second)
  }
}

class InteractionIntegrationTests: XCTestCase {
  @Mock private var custom: Custom

  func test_interaction_ended_shouldPass() {
    interaction(with: custom).ended()
  }

  func test_interaction_ended_whenAllMethodsCallsHaveBeenVerifuedShouldPass() {
    // Given
    custom.doSomething()

    // When
    then(custom).doSomething().called()

    // Then
    interaction(with: custom).ended()
  }

  func test_interaction_ended_whenAllReadPropertyCallsHaveBeenVerifuedShouldPass() {
    // Given
    _ = custom.read

    // When
    then(custom).read.get.called()

    // Then
    interaction(with: custom).ended()
  }

  func test_interaction_ended_whenAllWritePropertyCallsHaveBeenVerifuedShouldPass() {
    // Given
    _ = custom.write

    // When
    then(custom).write.get.called()

    // Then
    interaction(with: custom).ended()
  }

  func test_interaction_ended_whenAllReadSubscriptCallsHaveBeenVerifuedShouldPass() {
    // Given
    _ = custom[0, ""]

    // When
    then(custom)[0, ""].get.called()

    // Then
    interaction(with: custom).ended()
  }

  func test_interaction_ended_whenAllWriteSubscriptCallsHaveBeenVerifuedShouldPass() {
    // Given
    _ = custom[x: 0, y: 0]

    // When
    then(custom)[x: 0, y: 0].get.called()

    // Then
    interaction(with: custom).ended()
  }
}
