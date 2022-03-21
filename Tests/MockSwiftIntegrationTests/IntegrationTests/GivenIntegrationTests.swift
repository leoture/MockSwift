// GivenIntegrationTests.swift
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

import MockSwift
import XCTest

class GivenIntegrationTests: XCTestCase {
    @Mock private var custom: DummyProtocol

    func test_function_shouldReturnValueFromWillCompletion() {
        // Given
        given(custom).function(identifier: .not(.match(\.isEmpty)))
            .disambiguate(with: String.self)
            .will { parameters in (parameters[0] as? String ?? "") + "1" }

        // When
        let result: String? = try? custom.function(identifier: "value")

        // Then
        XCTAssertEqual(result, "value1")
    }

    func test_function_shouldThrowErrorFromWillCompletion() {
        // Given
        let expectedError = NSError(domain: "domain", code: 0)
        given(custom).function(identifier: .not(.match { $0.isEmpty }))
            .disambiguate(with: String.self)
            .will { _ in throw expectedError }

        // When
        var catchedError: NSError?
        do {
            let _: String = try custom.function(identifier: "value")
        } catch {
            catchedError = error as NSError
        }

        // Then
        XCTAssertTrue(catchedError === expectedError)
    }

    func test_function_shouldReturnValueFromWillReturnValue() {
        // Given
        given(custom).function(identifier: "value")
            .disambiguate(with: Int.self)
            .willReturn(42)

        // When
        let result: Int = custom.function(identifier: "value")

        // Then
        XCTAssertEqual(result, 42)
    }

    func test_function_shouldReturnValueFromWillReturnValues() {
        // Given
        given(custom).function(identifier: "value")
            .disambiguate(with: Int.self)
            .willReturn(0, 1, 2)

        // When
        let results: [Int] = [custom.function(identifier: "value"),
                              custom.function(identifier: "value"),
                              custom.function(identifier: "value"),
                              custom.function(identifier: "value")]

        // Then
        XCTAssertEqual(results, [0, 1, 2, 2])
    }

    func test_function_shouldReturnDefaultValueIfNoMatch() {
        // Given
        given(custom).function(identifier: .match { _ in false })
            .disambiguate(with: Int.self)
            .willReturn(42)

        // When
        let result: Int = custom.function(identifier: "value")

        // Then
        XCTAssertEqual(result, 0)
    }

    func test_function_shouldThrowFromWillThrowError() {
        // Given
        let expectedError = NSError(domain: "domain", code: 0)
        given(custom).function(identifier: .any())
            .disambiguate(with: String.self)
            .willThrow(expectedError)

        // When
        var catchedError: NSError?
        do {
            let _: String = try custom.function(identifier: "")
        } catch {
            catchedError = error as NSError
        }

        // Then
        XCTAssertTrue(catchedError === expectedError)
    }

    func test_function_shouldThrowFromWillThrowErrors() {
        // Given
        let expectedError1 = NSError(domain: "domain", code: 1)
        let expectedError2 = NSError(domain: "domain", code: 2)
        let expectedError3 = NSError(domain: "domain", code: 3)
        given(custom).function(identifier: .any())
            .disambiguate(with: String.self)
            .willThrow(expectedError1, expectedError2, expectedError3)

        // When
        let completion: () -> NSError? = {
            do {
                let _: String = try self.custom.function(identifier: "")
                return nil
            } catch {
                return error as NSError
            }
        }
        let catchedErrors: [NSError?] = [completion(),
                                         completion(),
                                         completion(),
                                         completion()]

        // Then
        XCTAssertEqual(catchedErrors, [expectedError1, expectedError2, expectedError3, expectedError3])
    }

    func test_given_shouldCallCompletionWithGivenCustom() {
        // Given
        var givenCustom: Given<DummyProtocol>?

        // When
        given(custom) { givenCustom = $0 }

        // Then
        XCTAssertNotNil(givenCustom)
    }

    func test_read_get_shouldReturnFromWillReturn() {
        // Given
        given(custom).read.get.willReturn("id")

        // When
        let read = custom.read

        // Then
        XCTAssertEqual(read, "id")
    }

    func test_write_get_shouldReturnFromWillReturn() {
        // Given
        given(custom).write.get.willReturn("id")

        // When
        let write = custom.write

        // Then
        XCTAssertEqual(write, "id")
    }

    func test_write_set_shouldReturnFromWillCompletion() {
        // Given
        let custom = Mock<DummyProtocol>()
        var completionParameters: [Any]?
        given(custom).write.set(.not(.match(\.isEmpty))).will { completionParameters = $0 }

        // When
        custom.write = "value"

        // Then
        XCTAssertEqual(completionParameters?.count, 1)
        XCTAssertEqual(completionParameters?[0] as? String, "value")
    }

    func test_write_set_shouldNotReturnFromWillCompletion() {
        // Given
        let custom = Mock<DummyProtocol>()
        var completionParameters: [Any]?
        given(custom).write.set("").will { completionParameters = $0 }

        // When
        custom.write = "value"

        // Then
        XCTAssertNil(completionParameters)
    }

    func test_subscriptFirstSecond_get_shouldReturnFromWillReturn() {
        // Given
        given(custom)[1, "a"].get.willReturn("hello")

        // When
        let result = custom[1, "a"]

        // Then
        XCTAssertEqual(result, "hello")
    }

    func test_subscriptXY_get_shouldReturnFromWillReturn() {
        // Given
        given(custom)[x: 1, y: 2].get.willReturn("value")

        // When
        let result = custom[x: 1, y: 2]

        // Then
        XCTAssertEqual(result, "value")
    }

    func test_subscriptXY_set_shouldReturnFromWillCompletion() {
        // Given
        let custom = Mock<DummyProtocol>()
        var completionParameters: [Any]?
        given(custom)[x: 1, y: 2].set(.not(.match(\.isEmpty))).will { completionParameters = $0 }

        // When
        custom[x: 1, y: 2] = "value"

        // Then
        XCTAssertEqual(completionParameters?.count, 3)
        XCTAssertEqual(completionParameters?[0] as? Int, 1)
        XCTAssertEqual(completionParameters?[1] as? Int, 2)
        XCTAssertEqual(completionParameters?[2] as? String, "value")
    }

    func test_subscriptXY_set_shouldNotReturnFromWillCompletion() {
        // Given
        let custom = Mock<DummyProtocol>()
        var completionParameters: [Any]?
        given(custom)[x: 1, y: 2].set("").will { completionParameters = $0 }

        // When
        custom[x: 1, y: 2] = "value"

        // Then
        XCTAssertNil(completionParameters)
    }
}
