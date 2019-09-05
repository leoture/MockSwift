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

  func test_doSomething() {
    // Given
    given(basic).doSomething().willReturn(0)
    given(basic).doSomething().willReturn("1")
    given(basic).doSomething(arg: .any).willReturn("2")
    given(basic).doSomething(arg1: .any, arg2: .any).willReturn("3")
    given(basic).doSomething(with: .any).willReturn("4")
    given(basic).doSomething(with: .any, and: .any).willReturn("5")

    // When
    basic.doSomething() as Void
    let result0: Int = basic.doSomething()
    let result1: String = basic.doSomething()
    let result2 = basic.doSomething(arg: "2")
    let result3 = basic.doSomething(arg1: "3", arg2: 3)
    let result4 = basic.doSomething(with: "4")
    let result5 = basic.doSomething(with: "5", and: true)

    //Then
    XCTAssertEqual(result0, 0)
    XCTAssertEqual(result1, "1")
    XCTAssertEqual(result2, "2")
    XCTAssertEqual(result3, "3")
    XCTAssertEqual(result4, "4")
    XCTAssertEqual(result5, "5")
    then(_basic).doSomething().disambiguate(with: Void.self).called(times: 1)
    then(_basic).doSomething().disambiguate(with: Int.self).called(times: 1)
    then(_basic).doSomething().disambiguate(with: String.self).called(times: 1)
    then(_basic).doSomething(arg: =="2").called(times: 1)
    then(_basic).doSomething(arg1: =="3", arg2: ==3).called(times: 1)
    then(_basic).doSomething(with: =="4").called(times: 1)
    then(_basic).doSomething(with: =="5", and: ==true).called(times: 1)
  }

}
