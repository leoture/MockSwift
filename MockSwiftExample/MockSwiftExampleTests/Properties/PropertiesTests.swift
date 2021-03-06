// PropertiesTests.swift
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
import MockSwift
@testable import MockSwiftExample
import XCTest

class PropertiesTests: XCTestCase {
  @Mock private var properties: Properties

  func test_property_withPredicates() {
    // Given
    var newValue: String?
    given(properties) {
      $0.variable.get.willReturn("variable")
      $0.variable.set(.match(\.isEmpty)).will { newValue = $0[0] as? String }
      $0.constant.get.willReturn(true)
    }

    // When
    let result1 = properties.variable
    properties.variable = ""
    let result2 = properties.constant

    // Then
    XCTAssertEqual(result1, "variable")
    XCTAssertEqual(newValue, "")
    XCTAssertEqual(result2, true)
  }

  func test_property_withTypes() {
    // Given
    var newValue: String?
    given(properties).variable
      .set("value2")
      .will { newValue = $0[0] as? String }

    // When
    properties.variable = "value2"

    // Then
    XCTAssertEqual(newValue, "value2")
  }
}
