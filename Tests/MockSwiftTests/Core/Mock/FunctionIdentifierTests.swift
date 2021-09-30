// FunctionIdentifierTests.swift
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

class FunctionIdentifierTests: XCTestCase {

    // MARK: - Function -> Void

    func test_callDescription_withNoParametersWhenFunctionReturnsVoid() {
        let description = FunctionIdentifier(function: "f()", return: Void.self)
            .callDescription(with: [])
        XCTAssertEqual(description, "f() -> Void")
    }

    func test_callDescription_withParametersWhenFuntionReturnsVoid() {
        let description = FunctionIdentifier(function: "f(arg1:arg2:arg3:arg4:)", return: Void.self)
            .callDescription(with: ["description1", 2, nil, { true }])
        XCTAssertEqual(description, "f(arg1: description1, arg2: 2, arg3: nil, arg4: (Function)) -> Void")
    }

    // MARK: - Function -> Int

    func test_callDescription_withNoParametersWhenFunctionReturnsInt() {
        let description = FunctionIdentifier(function: "f()", return: Int.self)
            .callDescription(with: [])
        XCTAssertEqual(description, "f() -> Int")
    }

    func test_callDescription_withParametersWhenFuntionReturnsInt() {
        let description = FunctionIdentifier(function: "f(arg1:arg2:arg3:arg4:)", return: Int.self)
            .callDescription(with: ["description1", 2, nil, { true }])
        XCTAssertEqual(description, "f(arg1: description1, arg2: 2, arg3: nil, arg4: (Function)) -> Int")
    }

    // MARK: - Function -> Function

    func test_callDescription_withNoParametersWhenFunctionReturnsFunction() {
        let description = FunctionIdentifier(function: "f()", return: ((Int) -> Bool).self)
            .callDescription(with: [])
        XCTAssertEqual(description, "f() -> (Int) -> Bool")
    }

    func test_callDescription_withParametersWhenFuntionReturnsFunction() {
        let description = FunctionIdentifier(function: "f(arg1:arg2:arg3:arg4:)", return: ((Int) -> Bool).self)
            .callDescription(with: ["description1", 2, nil, { (_: Int) in true }])
        XCTAssertEqual(description, "f(arg1: description1, arg2: 2, arg3: nil, arg4: (Function)) -> (Int) -> Bool")
    }

    // MARK: - Property -> Void

    func test_callDescription_whenGetVoidProperty() {
        let description = FunctionIdentifier(function: "variable", return: Void.self)
            .callDescription(with: [])
        XCTAssertEqual(description, "variable: Void")
    }

    func test_callDescription_whenSetVoidProperty() {
        let description = FunctionIdentifier(function: "variable", return: Void.self)
            .callDescription(with: [()])
        XCTAssertEqual(description, "variable = ()")
    }

    // MARK: - Property -> Int

    func test_callDescription_whenhGetIntProperty() {
        let description = FunctionIdentifier(function: "variable", return: Int.self)
            .callDescription(with: [])
        XCTAssertEqual(description, "variable: Int")
    }

    func test_callDescription_whenSetIntProperty() {
        let description = FunctionIdentifier(function: "variable", return: Int.self)
            .callDescription(with: [2])
        XCTAssertEqual(description, "variable = 2")
    }

    // MARK: - Property -> Function

    func test_callDescription_whenhGetFunctionProperty() {
        let description = FunctionIdentifier(function: "variable", return: ((Int) -> Bool).self)
            .callDescription(with: [])
        XCTAssertEqual(description, "variable: (Int) -> Bool")
    }

    func test_callDescription_whenSetFunctionProperty() {
        let description = FunctionIdentifier(function: "variable", return: ((Int) -> Bool).self)
            .callDescription(with: [ { (_: Int) in true } ])
        XCTAssertEqual(description, "variable = (Function)")
    }

    // MARK: - Subscript -> Void

    func test_callDescription_withGetVoidSubscript() {
        let description = FunctionIdentifier(function: "subscript(_:_:)", return: Void.self)
            .callDescription(with: [1, "description2"])
        XCTAssertEqual(description, "subscript(_: 1, _: description2) -> Void")
    }

    func test_callDescription_withSetVoidSubscript() {
        let description = FunctionIdentifier(function: "subscript(_:_:)", return: Void.self)
            .callDescription(with: [1, "description2", ()])
        XCTAssertEqual(description, "subscript(_: 1, _: description2) = ()")
    }

    // MARK: - Subscript -> Int

    func test_callDescription_withGetIntSubscript() {
        let description = FunctionIdentifier(function: "subscript(_:_:)", return: Int.self)
            .callDescription(with: [1, "description2"])
        XCTAssertEqual(description, "subscript(_: 1, _: description2) -> Int")
    }

    func test_callDescription_withSetIntSubscript() {
        let description = FunctionIdentifier(function: "subscript(_:_:)", return: Int.self)
            .callDescription(with: [1, "description2", 0])
        XCTAssertEqual(description, "subscript(_: 1, _: description2) = 0")
    }

    // MARK: - Subscript -> Function

    func test_callDescription_withGetFunctionSubscript() {
        let description = FunctionIdentifier(function: "subscript(_:_:)", return: ((Int) -> Bool).self)
            .callDescription(with: [1, "description2"])
        XCTAssertEqual(description, "subscript(_: 1, _: description2) -> (Int) -> Bool")
    }

    func test_callDescription_withSetFunctionSubscript() {
        let description = FunctionIdentifier(function: "subscript(_:_:)", return: Int.self)
            .callDescription(with: [1, "description2", { (_: Int) in true }])
        XCTAssertEqual(description, "subscript(_: 1, _: description2) = (Function)")
    }
}
