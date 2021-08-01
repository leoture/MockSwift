// InteractionIntegrationTests.swift
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

class InteractionIntegrationTests: XCTestCase {
    @Mock private var custom: DummyProtocol

    func test_interaction_ended_shouldPass() {
        interaction(with: custom).ended()
    }

    func test_interaction_ended_whenAllMethodsCallsHaveBeenVerifiedShouldPass() {
        // Given
        let _: Int = custom.function(identifier: "id")

        // When
        then(custom).function(identifier: "id").disambiguate(with: Int.self).called()

        // Then
        interaction(with: custom).ended()
    }

    func test_interaction_ended_whenAllReadPropertyCallsHaveBeenVerifiedShouldPass() {
        // Given
        _ = custom.read

        // When
        then(custom).read.get.called()

        // Then
        interaction(with: custom).ended()
    }

    func test_interaction_ended_whenAllWritePropertyCallsHaveBeenVerifiedShouldPass() {
        // Given
        _ = custom.write

        // When
        then(custom).write.get.called()

        // Then
        interaction(with: custom).ended()
    }

    func test_interaction_ended_whenAllReadSubscriptCallsHaveBeenVerifiedShouldPass() {
        // Given
        _ = custom[0, ""]

        // When
        then(custom)[0, ""].get.called()

        // Then
        interaction(with: custom).ended()
    }

    func test_interaction_ended_whenAllWriteSubscriptCallsHaveBeenVerifiedShouldPass() {
        // Given
        _ = custom[x: 0, y: 0]

        // When
        then(custom)[x: 0, y: 0].get.called()

        // Then
        interaction(with: custom).ended()
    }
}
