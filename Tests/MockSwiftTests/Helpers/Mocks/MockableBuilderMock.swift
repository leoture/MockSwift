//MockableBuilderMock.swift
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

// swiftlint:disable large_tuple
// swiftlint:disable force_cast
class MockableBuilderMock: MockableBuilder {

  var mockableReturn: Any!
  var mockableReceived: [(parameters: [ParameterType], function: String, file: String, line: UInt)] = []
  func mockable<ReturnType>(
    _ parameters: ParameterType...,
    function: String,
    file: StaticString,
    line: UInt) -> Mockable<ReturnType> {
    mockableReceived.append((parameters, function, file.description, line))
    return mockableReturn as! Mockable<ReturnType>
  }

  var mockablePredicatesReturn: Any!
  var mockablePredicatesReceived: [(predicates: [AnyPredicate], function: String, file: String, line: UInt)] = []
  func mockable<ReturnType>(predicates: [AnyPredicate],
                            function: String,
                            file: StaticString,
                            line: UInt) -> Mockable<ReturnType> {
    mockablePredicatesReceived.append((predicates, function, file.description, line))
    return mockablePredicatesReturn as! Mockable<ReturnType>
  }
}
