//EscapingTests.swift
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
import XCTest
import MockSwift
@testable import MockSwiftExample

class EscapingTests: XCTestCase {
  @Mock private var escaping: Escaping

  func test_call_withTypes() {
    // block cannot be used as predicate.
    // Given
    let block: (String) -> Bool = { $0.isEmpty }
    given(escaping).call(block).will {
      ($0[0] as! (String) -> Bool)("")
    }

    // When
    let result = escaping.call(block)

    //Then
    XCTAssertFalse(result)
    then(escaping).call(block).called(times: 0)
  }

  func test_call_withPredicates() {
    // Given
    given(escaping).call(.any()).will {
      ($0[0] as! (String) -> Bool)("")
    }

    // When
    let result = escaping.call { $0.isEmpty }

    //Then
    XCTAssertTrue(result)
    then(escaping).call(.any()).called()
  }
}
