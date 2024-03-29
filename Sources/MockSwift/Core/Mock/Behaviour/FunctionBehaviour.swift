// FunctionBehaviour.swift
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

struct FunctionBehaviour {
    typealias Handler = ([ParameterType]) throws -> Any

    let identifier: UUID
    let location: Location
    let handler: Handler

    init(identifier: UUID = UUID(),
         location: Location = Location(),
         handler: @escaping Handler = { _ in () }) {
        self.identifier = identifier
        self.location = location
        self.handler = handler
    }

    func handle<ReturnType>(with parameters: [ParameterType]) -> ReturnType? {
        try? handler(parameters) as? ReturnType
    }

    func handleThrowable<ReturnType>(with parameters: [ParameterType]) throws -> ReturnType? {
        try handler(parameters) as? ReturnType
    }
}

struct Location {
    let file: StaticString
    let line: UInt

    init(file: StaticString = "",
         line: UInt = 0) {
        self.file = file
        self.line = line
    }
}
