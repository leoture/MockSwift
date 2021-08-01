// ThenIntegrationTests.swift
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

class ThenIntegrationTests: XCTestCase {
    @Mock private var custom: DummyProtocol

    func test_function_shouldBeCalledWhenParametersMatched() {
        // Given

        // When
        let _: String? = try? custom.function(identifier: "value")
        let _: String? = try? custom.function(identifier: "value")

        // Then
        then(custom).function(identifier: .match { !$0.isEmpty })
            .disambiguate(with: String.self)
            .called(times: >1)
    }

    func test_function_should_beCalledInOrder() {
        // Given
        let custom1 = Mock<DummyProtocol>()
        let custom2 = Mock<DummyProtocol>()

        // When
        let _: Int = custom1.function(identifier: "1")
        let _: Int = custom2.function(identifier: "2")
        let _: Int = custom2.function(identifier: "2")
        let _: Int = custom1.function(identifier: "4")
        let _: Int = custom1.function(identifier: "3")

        // Then
        var assertion = then(custom1).function(identifier: .any())
            .disambiguate(with: Int.self).called()
        assertion = then(custom2).function(identifier: =="2")
            .disambiguate(with: Int.self).called(times: 2, after: assertion)
        assertion = then(custom1).function(identifier: =="3")
            .disambiguate(with: Int.self).called(after: assertion)
        assertion = then(custom2).function(identifier: .any())
            .disambiguate(with: Int.self).called(times: 0, after: assertion)
        then(custom1).function(identifier: =="4")
            .disambiguate(with: Int.self).called(times: 0, after: assertion)
    }

    func test_then_shouldCallCompletionWithThenCustom() {
        // Given
        var thenCustom: Then<DummyProtocol>?

        // When
        then(custom) { thenCustom = $0 }

        // Then
        XCTAssertNotNil(thenCustom)
    }

    func test_receivedParameters_whenParametersMatched() {
        // Given

        // When
        let _: String? = try? custom.function(identifier: "arg1")
        let _: String? = try? custom.function(identifier: "")
        let _: String? = try? custom.function(identifier: "arg2")

        // Then
        let receivedParameters = then(custom).function(identifier: .not(.match(\.isEmpty)))
            .disambiguate(with: String.self)
            .receivedParameters
        XCTAssertEqual(receivedParameters as? [[String]], [["arg1"], ["arg2"]])
    }

    func test_callCount_whenParametersMatched() {
        // Given

        // When
        let _: String? = try? custom.function(identifier: "arg1")
        let _: String? = try? custom.function(identifier: "")
        let _: String? = try? custom.function(identifier: "arg2")

        // Then
        let callCount = then(custom).function(identifier: .not(.match(\.isEmpty)))
            .disambiguate(with: String.self)
            .callCount
        XCTAssertEqual(callCount, 2)
    }

    func test_Readable_get_shouldBeCalled() {
        // Given

        // When
        _ = custom.read
        _ = custom.read

        // Then
        then(custom).read.get.called(times: 2)
    }

    func test_Writable_get_shouldBeCalled() {
        // Given

        // When
        _ = custom.write
        _ = custom.write

        // Then
        then(custom).write.get.called(times: 2)
    }

    func test_Writable_set_shouldBeCalledWhenParametersMatched() {
        // Given
        let custom = Mock<DummyProtocol>()

        // When
        custom.write = "value"

        // Then
        then(custom).write.set(.not(.match(\.isEmpty))).called()
        then(custom).write.set("value").called()
    }

    func test_Writable_set_shouldNotBeCalledWhenParametersDontMatch() {
        // Given
        let custom = Mock<DummyProtocol>()

        // When
        custom.write = "value"

        // Then
        then(custom).write.set(.match(\.isEmpty)).called(times: 0)
    }

    func test_subscriptFirstSecond_get_shouldBeCalled() {
        // Given

        // When
        _ = custom[1, "a"]
        _ = custom[1, "b"]

        // Then
        then(custom)[==1, .match { $0 == "a" || $0 == "b" }].get.called(times: 2)
    }

    func test_subscriptXY_get_shouldBeCalled() {
        // Given

        // When
        _ = custom[x: 1, y: 2]

        // Then
        then(custom)[x: 1, y: 2].get.called(times: 1)
    }

    func test_subscriptXY_set_shouldBeCalledWhenParametersMatched() {
        // Given
        let custom = Mock<DummyProtocol>()

        // When
        custom[x: 1, y: 2] = "value"

        // Then
        then(custom)[x: 1, y: 2].set(.not(.match(\.isEmpty))).called()
        then(custom)[x: 1, y: 2].set("value").called()
    }

    func test_subscriptXY_set_shouldNotBeCalledWhenParametersDontMatch() {
        // Given
        let custom = Mock<DummyProtocol>()

        // When
        custom[x: 1, y: 2] = "value"

        // Then
        then(custom)[x: 1, y: 2].set(.match(\.isEmpty)).called(times: 0)
    }
}
