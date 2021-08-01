// Interaction.swift
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

func interaction<WrappedType>(_ value: WrappedType,
                              errorHandler: ErrorHandler,
                              failureRecorder: FailureRecorder) -> Interaction<WrappedType> {
    guard let mock = value as? Mock<WrappedType> else {
        return errorHandler.handle(InternalError.cast(source: value, target: Mock<WrappedType>.self))
    }
    return Interaction(callRegister: mock,
                       behaviourRegister: mock,
                       failureRecorder: failureRecorder)
}

// MARK: - Public Global Methods

/// Creates an `Interaction` based on `value`.
public func interaction<WrappedType>(with value: WrappedType) -> Interaction<WrappedType> {
    interaction(value, errorHandler: ErrorHandler(), failureRecorder: XCTestFailureRecorder())
}

/// `Interaction` is used to verify method calls.
/// - SeeAlso: `Then`
public class Interaction<WrappedType> {
    // MARK: - Properties

    private let callRegister: CallRegister
    private let behaviourRegister: BehaviourRegister
    private let failureRecorder: FailureRecorder

    // MARK: - Init

    init(callRegister: CallRegister,
         behaviourRegister: BehaviourRegister,
         failureRecorder: FailureRecorder) {
        self.callRegister = callRegister
        self.behaviourRegister = behaviourRegister
        self.failureRecorder = failureRecorder
    }

    /// Checks that the `WrappedType` value has no calls to check anymore.
    /// - Parameters:
    ///   - file: The file name where the method is called.
    ///   - line: The line where the method is called.
    public func ended(file: StaticString = #file, line: UInt = #line) {
        if !callRegister.allCallHaveBeenVerified {
            failureRecorder.recordFailure(message: "\(WrappedType.self) expects to have no more interactions to check.",
                                          file: file,
                                          line: line)
        }
    }

    /// Checks that the `WrappedType` value has no used Behaviours.
    /// - Parameters:
    ///   - file: The file name where the method is called.
    ///   - line: The line where the method is called.
    public func failOnUnusedBehaviours(file: StaticString = #file, line: UInt = #line) {
        if !behaviourRegister.allBehavioursHaveBeenUsed {
            failureRecorder.recordFailure(message: "\(WrappedType.self) has unused behaviours.",
                                          file: file,
                                          line: line)
        }
    }
}
