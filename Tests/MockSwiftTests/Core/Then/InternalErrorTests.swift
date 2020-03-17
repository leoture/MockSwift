// InternalErrorTests.swift
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

import Foundation
@testable import MockSwift
import XCTest

class InternalErrorTests: XCTestCase {
  func test_description_withCast() {
    let error = InternalError.cast(source: true, target: Mock<Bool>.self)
    XCTAssertEqual(error.description, "true can not be cast to Mock<Bool>.")
  }

  func test_description_withCastTwice() {
    let error = InternalError.castTwice(source: true, firstTarget: String.self, secondTarget: [Int].self)
    XCTAssertEqual(error.description, "true can not be cast to String or to Array<Int>.")
  }

  func test_description_withNoDefinedBehaviour() {
    let error = InternalError.noDefinedBehaviour(for: FunctionIdentifier.stub(), with: [0, "1"])
    XCTAssertEqual(error.description, "Attempt to call function() -> ()" +
      " but there is no defined behaviour for this call.")
  }

  func test_description_withTooManyDefinedBehaviour() {
    let error = InternalError.tooManyDefinedBehaviour(for: FunctionIdentifier.stub(), with: [0, "1"])
    XCTAssertEqual(error.description, "Attempt to call function() -> ()" +
      " but there too many defined behaviour.")
  }
}
