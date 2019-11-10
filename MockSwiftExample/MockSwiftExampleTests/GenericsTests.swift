//GenericsTests.swift
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
@testable import MockSwiftExample

class GenericsTests: XCTestCase {
  @Mock private var generics: Generics

  func test_doSomething_withPredicates() {
    // Given
    var blockDone = false
    let error = NSError(domain: "domain", code: 0)
    given(generics) {
      $0.doSomething().willReturn(0)
      $0.doSomething().willReturn("1")
      $0.doSomething(with: .match(any: [Int].self, when: \.isEmpty)).will { _ in blockDone = true }
      $0.doSomething(arg: .isTrue()).willThrow(error)
      $0.doSomething(arg1: ==[2], arg2: .isNil()).willReturn(2)
      $0.doSomething(with: ==3, and: =="3").willReturn(true)
    }

    // When
    generics.doSomething(with: [])
    let result0: Int  = generics.doSomething()
    let result1: String  = generics.doSomething()
    var resultError: NSError?
    do {
      _ = try generics.doSomething(arg: true)
    } catch {
      resultError = error as NSError
    }
    let result2 = generics.doSomething(arg1: [2], arg2: nil)
    let result3 = generics.doSomething(with: 3, and: "3")

    //Then
    XCTAssertTrue(blockDone)
    XCTAssertEqual(result0, 0)
    XCTAssertEqual(result1, "1")
    XCTAssertEqual(result2, 2)
    XCTAssertTrue(result3)
    XCTAssertTrue(resultError === error)
    then(generics) {
      $0.doSomething().disambiguate(with: Int.self).called(times: 1)
      $0.doSomething().disambiguate(with: String.self).called(times: 1)
      $0.doSomething(with: .match(any: [Int].self, when: \.isEmpty)).called(times: 1)
      $0.doSomething(arg: .isTrue()).called(times: 1)
      $0.doSomething(arg1: ==[2], arg2: .isNil()).called(times: 1)
      $0.doSomething(with: ==3, and: =="3").called(times: 1)
    }
  }

  func test_doSomething_withTypes() {
    // Given
    var blockDone = false
    let error = NSError(domain: "domain", code: 0)
    given(generics) {
      $0.doSomething().willReturn(0)
      $0.doSomething().willReturn("1")
      $0.doSomething(with: []).will { _ in blockDone = true }
      $0.doSomething(arg: true).willThrow(error)
      $0.doSomething(arg1: [2], arg2: nil).willReturn(2)
      $0.doSomething(with: 3, and: "3").willReturn(true)
    }

    // When
    generics.doSomething(with: [])
    let result0: Int  = generics.doSomething()
    let result1: String  = generics.doSomething()
    var resultError: NSError?
    do {
      _ = try generics.doSomething(arg: true)
    } catch {
      resultError = error as NSError
    }
    let result2 = generics.doSomething(arg1: [2], arg2: nil)
    let result3 = generics.doSomething(with: 3, and: "3")

    //Then
    XCTAssertTrue(blockDone)
    XCTAssertEqual(result0, 0)
    XCTAssertEqual(result1, "1")
    XCTAssertEqual(result2, 2)
    XCTAssertTrue(result3)
    XCTAssertTrue(resultError === error)
    then(generics) {
      $0.doSomething().disambiguate(with: Int.self).called(times: 1)
      $0.doSomething().disambiguate(with: String.self).called(times: 1)
      $0.doSomething(with: []).called(times: 1)
      $0.doSomething(arg: true).called(times: 1)
      $0.doSomething(arg1: [2], arg2: nil).called(times: 1)
      $0.doSomething(with: 3, and: "3").called(times: 1)
    }
  }
}
