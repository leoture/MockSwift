//MockSwiftExampleTests.swift
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

class MockSwiftExampleTests: XCTestCase {
  @Mock private var basic: Basic

  func test_doSomething_withPredicates() {
    // Given
    var blockDone = false
    given(basic) {
      $0.doSomething().disambiguate(with: Void.self).will { _ in blockDone = true }
      $0.doSomething().willReturn(0)
      $0.doSomething().willReturn(nil)
      $0.doSomething(arg: .any()).willReturn("2")
      $0.doSomething(arg1: =="3", arg2: .isNil()).willReturn("3")
      $0.doSomething(with: =="4").willReturn("4")
      $0.doSomething(with: =="5", and: .isTrue()).willReturn("5")
    }

    // When
    basic.doSomething() as Void
    let result0: Int = basic.doSomething()
    let result1: String? = basic.doSomething()
    let result2 = basic.doSomething(arg: "2")
    let result3 = basic.doSomething(arg1: "3", arg2: nil)
    let result4 = basic.doSomething(with: "4")
    let result5 = basic.doSomething(with: "5", and: true)

    //Then
    XCTAssertTrue(blockDone)
    XCTAssertEqual(result0, 0)
    XCTAssertNil(result1)
    XCTAssertEqual(result2, "2")
    XCTAssertEqual(result3, "3")
    XCTAssertEqual(result4, "4")
    XCTAssertEqual(result5, "5")
    then(basic) {
      $0.doSomething().disambiguate(with: Void.self).called(times: 1)
      $0.doSomething().disambiguate(with: Int.self).called(times: 1)
      $0.doSomething().disambiguate(with: String?.self).called(times: 1)
      $0.doSomething(arg: =="2").called(times: 1)
      $0.doSomething(arg1: =="3", arg2: .isNil()).called(times: 1)
      $0.doSomething(with: =="4").called(times: 1)
      $0.doSomething(with: =="5", and: .isTrue()).called(times: 1)
    }
  }

  func test_doSomething_withTypes() {
    // Given
    var blockDone = false
    given(basic) {
      $0.doSomething().disambiguate(with: Void.self).will { _ in blockDone = true }
      $0.doSomething().willReturn(0)
      $0.doSomething().willReturn(nil)
      $0.doSomething(arg: "2").willReturn("2")
      $0.doSomething(arg1: "3", arg2: nil).willReturn("3")
      $0.doSomething(with: "4").willReturn("4")
      $0.doSomething(with: "5", and: true).willReturn("5")
    }

    // When
    basic.doSomething() as Void
    let result0: Int = basic.doSomething()
    let result1: String? = basic.doSomething()
    let result2 = basic.doSomething(arg: "2")
    let result3 = basic.doSomething(arg1: "3", arg2: nil)
    let result4 = basic.doSomething(with: "4")
    let result5 = basic.doSomething(with: "5", and: true)

    //Then
    XCTAssertTrue(blockDone)
    XCTAssertEqual(result0, 0)
    XCTAssertNil(result1)
    XCTAssertEqual(result2, "2")
    XCTAssertEqual(result3, "3")
    XCTAssertEqual(result4, "4")
    XCTAssertEqual(result5, "5")
    then(basic) {
      $0.doSomething().disambiguate(with: Void.self).called(times: 1)
      $0.doSomething().disambiguate(with: Int.self).called(times: 1)
      $0.doSomething().disambiguate(with: String?.self).called(times: 1)
      $0.doSomething(arg: "2").called(times: 1)
      $0.doSomething(arg1: "3", arg2: nil).called(times: 1)
      $0.doSomething(with: "4").called(times: 1)
      $0.doSomething(with: "5", and: true).called(times: 1)
    }
  }
}
