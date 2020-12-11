// GlobalStub.swift
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

/// GlobalStub represents an entity able to give a stub value.
public protocol GlobalStub {
    /// Creates a stub value of `Self`.
    static func stub() -> Self
}

// MARK: - ExpressibleByNilLiteral

extension GlobalStub where Self: ExpressibleByNilLiteral {
    public static func stub() -> Self { nil }
}

extension Optional: GlobalStub {}

// MARK: - ExpressibleByBooleanLiteral

extension GlobalStub where Self: ExpressibleByBooleanLiteral {
    public static func stub() -> Self { false }
}

extension Bool: GlobalStub {}

// MARK: - ExpressibleByIntegerLiteral

extension GlobalStub where Self: ExpressibleByIntegerLiteral {
    public static func stub() -> Self { 0 }
}

extension Int: GlobalStub {}

// MARK: - ExpressibleByFloatLiteral

extension GlobalStub where Self: ExpressibleByFloatLiteral {
    public static func stub() -> Self { 0.0 }
}

extension Double: GlobalStub {
    public static func stub() -> Self { 0.0 }
}
extension Float: GlobalStub {
    public static func stub() -> Self { 0.0 }
}
extension Float80: GlobalStub {
    public static func stub() -> Self { 0.0 }
}
extension Decimal: GlobalStub {
    public static func stub() -> Self { 0.0 }
}
extension NSNumber: GlobalStub {
    public static func stub() -> Self { 0.0 }
}

// MARK: - ExpressibleByStringLiteral

extension GlobalStub where Self: ExpressibleByStringLiteral {
    public static func stub() -> Self { "" }
}
extension String: GlobalStub {}
extension Substring: GlobalStub {}
extension StaticString: GlobalStub {}

// MARK: - ExpressibleByStringInterpolation

extension GlobalStub where Self: ExpressibleByStringInterpolation {
    public static func stub() -> Self { "" }
}

// MARK: - ExpressibleByArrayLiteral

extension GlobalStub where Self: ExpressibleByArrayLiteral {
    public static func stub() -> Self { [] }
}

extension Array: GlobalStub {}
extension ArraySlice: GlobalStub {}
extension ContiguousArray: GlobalStub {}
extension IndexPath: GlobalStub {}
extension Set: GlobalStub {}

// MARK: - ExpressibleByDictionaryLiteral

extension GlobalStub where Self: ExpressibleByDictionaryLiteral {
    public static func stub() -> Self { [:] }
}

extension Dictionary: GlobalStub {}
extension KeyValuePairs: GlobalStub {}
