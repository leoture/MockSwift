// GlobalStubExtensionTests.swift
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

class GlobalStubExtensionTests: XCTestCase {
    // MARK: - ExpressibleByNilLiteral

    func test_stub_Optional() { XCTAssertEqual(Int?.stub(), nil) }

    // MARK: - ExpressibleByBooleanLiteral

    func test_stub_Bool() { XCTAssertEqual(Bool.stub(), false) }

    // MARK: - ExpressibleByIntegerLiteral

    func test_stub_Int() { XCTAssertEqual(Int.stub(), 0) }

    // MARK: - ExpressibleByFloatLiteral

    func test_stub_Double() { XCTAssertEqual(Double.stub(), 0.0) }
    func test_stub_Float() { XCTAssertEqual(Float.stub(), 0.0) }
    func test_stub_Float80() { XCTAssertEqual(Float80.stub(), 0.0) }
    func test_stub_Decimal() { XCTAssertEqual(Decimal.stub(), 0.0) }
    func test_stub_NSNumber() { XCTAssertEqual(NSNumber.stub(), 0.0) }

    // MARK: - ExpressibleByStringLiteral

    func test_stub_String() { XCTAssertEqual(String.stub(), "") }
    func test_stub_Substring() { XCTAssertEqual(Substring.stub(), "") }
    func test_stub_StaticString() { XCTAssertNotNil(StaticString.stub()) }

    // MARK: - ExpressibleByArrayLiteral

    func test_stub_Array() { XCTAssertEqual([Int].stub(), []) }
    func test_stub_ArraySlice() { XCTAssertEqual(ArraySlice<Int>.stub(), []) }
    func test_stub_ContiguousArray() { XCTAssertEqual(ContiguousArray<Int>.stub(), []) }
    func test_stub_IndexPath() { XCTAssertEqual(IndexPath.stub(), []) }
    func test_stub_Set() { XCTAssertEqual(Set<Int>.stub(), []) }

    // MARK: - ExpressibleByDictionaryLiteral
    
    func test_stub_Dictionary() { XCTAssertEqual([Int: Int].stub(), [:]) }
    func test_stub_KeyValuePairs() { XCTAssertNotNil(KeyValuePairs<Int, Int>.stub()) }
}
