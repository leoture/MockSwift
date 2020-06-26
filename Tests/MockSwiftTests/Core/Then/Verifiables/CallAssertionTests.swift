// CallAssertionTests.swift
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

@testable import MockSwift
import XCTest

class CallAssertionTests: XCTestCase {
  func test_isValid_should_returnTrue() {
    let assertion = CallAssertion(times: >2,
                                  functionIdentifier: .stub(),
                                  parametersPredicates: [],
                                  calls: [.stub(), .stub(), .stub()])
    XCTAssertTrue(assertion.isValid)
  }

  func test_isValid_should_returnFalse() {
    let assertion = CallAssertion(times: >2,
                                  functionIdentifier: .stub(),
                                  parametersPredicates: [],
                                  calls: [.stub(), .stub()])
    XCTAssertFalse(assertion.isValid)
  }

  func test_description_should_returnCorrectDescription_when_isValidAndPreviousNotNil() {
    let previousAssertion = AssertionMock()
    previousAssertion.descriptionReturn = "previous"
    let functionIdentifier = FunctionIdentifier(function: "function(arg:)", return: String.self)
    let assertion = CallAssertion(times: >2,
                                  functionIdentifier: functionIdentifier,
                                  parametersPredicates: [Predicate<Int>.eq(1)],
                                  calls: [.stub(), .stub(), .stub()],
                                  previous: previousAssertion)
    XCTAssertEqual(assertion.description, "function(arg: 1) -> String has been called more than 2 time(s)" +
      " after previous.")
  }

  func test_description_should_returnCorrectDescription_when_isValidAndPreviousNil() {
    let functionIdentifier = FunctionIdentifier(function: "function(arg:)", return: String.self)
    let assertion = CallAssertion(times: >2,
                                  functionIdentifier: functionIdentifier,
                                  parametersPredicates: [Predicate<Int>.eq(1)],
                                  calls: [.stub(), .stub(), .stub()],
                                  previous: nil)
    XCTAssertEqual(assertion.description, "function(arg: 1) -> String has been called more than 2 time(s).")
  }

  func test_description_should_returnCorrectDescription_when_isNotValidAndPreviousNotNil() {
    let previousAssertion = AssertionMock()
    previousAssertion.descriptionReturn = "previous"
    let functionIdentifier = FunctionIdentifier(function: "function(arg:)", return: String.self)
    let assertion = CallAssertion(times: >2,
                                  functionIdentifier: functionIdentifier,
                                  parametersPredicates: [Predicate<Int>.eq(1)],
                                  calls: [.stub(), .stub()],
                                  previous: previousAssertion)
    XCTAssertEqual(assertion.description, "function(arg: 1) -> String" +
      " is expected to be called more than 2 time(s) but is called 2 time(s)" +
      " after previous.")
  }

  func test_description_should_returnCorrectDescription_when_isNotValidAndPreviousNil() {
    let functionIdentifier = FunctionIdentifier(function: "function(arg:)", return: String.self)
    let assertion = CallAssertion(times: >2,
                                  functionIdentifier: functionIdentifier,
                                  parametersPredicates: [Predicate<Int>.eq(1)],
                                  calls: [.stub(), .stub()],
                                  previous: nil)
    XCTAssertEqual(assertion.description, "function(arg: 1) -> String" +
      " is expected to be called more than 2 time(s) but is called 2 time(s).")
  }

  func test_firstValidTime_should_returnMaximumTimeOfMinimumFunctionCallList_when_callsNotEmpty() {
    let assertion = CallAssertion(times: >1,
                                  functionIdentifier: .stub(),
                                  parametersPredicates: [Predicate<Int>.eq(1)],
                                  calls: [.stub(time: 1), .stub(time: 2), .stub(time: 3)])
    XCTAssertEqual(assertion.firstValidTime, 2)
  }

  func test_firstValidTime_should_returnPreviousFirstValidTime_when_callsEmptyAndPreviousNotNil() {
    let previousAssertion = AssertionMock()
    previousAssertion.firstValidTimeReturn = 3
    let assertion = CallAssertion(times: ==0,
                                  functionIdentifier: .stub(),
                                  parametersPredicates: [],
                                  calls: [],
                                  previous: previousAssertion)
    XCTAssertEqual(assertion.firstValidTime, 3)
  }

  func test_firstValidTime_should_returnZero_when_callsEmptyAndPreviousNil() {
    let assertion = CallAssertion(times: ==0,
                                  functionIdentifier: .stub(),
                                  parametersPredicates: [],
                                  calls: [],
                                  previous: nil)
    XCTAssertEqual(assertion.firstValidTime, 0)
  }
}
