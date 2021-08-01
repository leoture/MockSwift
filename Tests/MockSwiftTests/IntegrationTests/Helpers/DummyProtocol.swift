//DummyProtocol.swift
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

protocol DummyProtocol {
    var write: String { get set }
    var read: String { get }
    subscript(first: Int, second: String) -> String { get }
    subscript(x first: Int, y second: Int) -> String { get set }
    func function(identifier: String) -> Int
    func function(identifier: String) throws -> String
}

extension Mock: DummyProtocol where WrappedType == DummyProtocol {
    var write: String {
        get { mocked() }
        set { mocked(newValue) }
    }

    var read: String {
        mocked()
    }

    subscript(first: Int, second: String) -> String {
        mocked(first, second)
    }

    subscript(x first: Int, y second: Int) -> String {
        get {
            mocked(first, second)
        }
        set {
            mocked(first, second, newValue)
        }
    }

    func function(identifier: String) -> Int { mocked(identifier) }
    func function(identifier: String) throws -> String { try mockedThrowable(identifier) }
}

extension Given where WrappedType == DummyProtocol {
    var write: MockableProperty.Writable<String> { mockable() }

    var read: MockableProperty.Readable<String> { mockable() }

    subscript(first: Int, second: String) -> MockableSubscript.Readable<String> {
        mockable(first, second)
    }

    subscript(first: Predicate<Int>, second: Predicate<String>) -> MockableSubscript.Readable<String> {
        mockable(first, second)
    }

    subscript(x first: Int, y second: Int) -> MockableSubscript.Writable<String> {
        mockable(first, second)
    }

    subscript(x first: Predicate<Int>, y second: Predicate<Int>) -> MockableSubscript.Writable<String> {
        mockable(first, second)
    }

    func function(identifier: String) -> Mockable<Int> { mockable(identifier) }
    func function(identifier: Predicate<String>) -> Mockable<Int> { mockable(identifier) }

    func function(identifier: String) -> Mockable<String> { mockable(identifier) }
    func function(identifier: Predicate<String>) -> Mockable<String> { mockable(identifier) }
}

extension Then where WrappedType == DummyProtocol {
    var write: VerifiableProperty.Writable<String> { verifiable() }

    var read: VerifiableProperty.Readable<String> { verifiable() }

    subscript(first: Int, second: String) -> VerifiableSubscript.Readable<String> {
        verifiable(first, second)
    }

    subscript(first: Predicate<Int>, second: Predicate<String>) -> VerifiableSubscript.Readable<String> {
        verifiable(first, second)
    }

    subscript(x first: Int, y second: Int) -> VerifiableSubscript.Writable<String> {
        verifiable(first, second)
    }

    subscript(x first: Predicate<Int>, y second: Predicate<Int>) -> VerifiableSubscript.Writable<String> {
        verifiable(first, second)
    }

    func function(identifier: String) -> Verifiable<Int> { verifiable(identifier) }
    func function(identifier: Predicate<String>) -> Verifiable<Int> { verifiable(identifier) }

    func function(identifier: String) -> Verifiable<String> { verifiable(identifier) }
    func function(identifier: Predicate<String>) -> Verifiable<String> { verifiable(identifier) }
}
