// Verifiable.swift
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

/// Represents a function call that returns `ReturnType` and can be checked.
public class Verifiable<ReturnType> {
    // MARK: - Properties

    private let callRegister: CallRegister
    private let functionIdentifier: FunctionIdentifier
    private let parametersPredicates: [AnyPredicate]
    private let failureRecorder: FailureRecorder

    // MARK: - Public Properties

    /// Return a list of all parameters' list with whom the function was called.
    public var receivedParameters: [[ParameterType]] {
        callRegister.recordedCalls(for: functionIdentifier, when: parametersPredicates)
            .map { $0.parameters }
    }

    /// Return the number of times that the function was called.
    public var callCount: Int {
        callRegister.recordedCalls(for: functionIdentifier, when: parametersPredicates)
            .count
    }

    // MARK: - Init

    init(callRegister: CallRegister,
         functionIdentifier: FunctionIdentifier,
         parametersPredicates: [AnyPredicate],
         failureRecorder: FailureRecorder) {
        self.callRegister = callRegister
        self.functionIdentifier = functionIdentifier
        self.parametersPredicates = parametersPredicates
        self.failureRecorder = failureRecorder
    }

    // MARK: - Public Methods

    /// Used to disambiguate the `ReturnType`.
    /// - Parameter type: The type to disambiguate.
    /// - Returns: `self` with `ReturnType` disambiguated.
    public func disambiguate(with type: ReturnType.Type) -> Self { self }

    /// Checks that the function has been called a number of times corresponding to the predicate.
    /// - Parameter times: Predicate that corresponds to the number of calls.
    /// - Parameter assertion: Previous assertion. nil by default.
    /// - Parameter file: File where `called` is called.
    /// - Parameter line: Line where `called`is called.
    /// - Returns: A new `Assertion`.
    /// - Important:
    /// When **assertion** is specify, only calls that appear after
    /// the minimum amount of calls required by the previous assertion will be considered.
    @discardableResult
    public func called(times: Predicate<Int> = >0,
                       after assertion: Assertion? = nil,
                       file: StaticString = #file,
                       line: UInt = #line) -> Assertion {
        var calls = callRegister.recordedCalls(for: functionIdentifier, when: parametersPredicates)

        if let assertion = assertion {
            if assertion.isValid {
                let startedTime = assertion.firstValidTime
                calls = calls.filter { $0.time > startedTime }
            } else {
                failureRecorder.recordFailure(message: assertion.description, file: file, line: line)
            }

        }

        calls.forEach { self.callRegister.makeCallVerified(for: $0.identifier) }

        let currentAssertion = CallAssertion(times: times,
                                             functionIdentifier: functionIdentifier,
                                             parametersPredicates: parametersPredicates,
                                             calls: calls,
                                             previous: assertion)

        if !currentAssertion.isValid {
            failureRecorder.recordFailure(message: currentAssertion.description, file: file, line: line)
        }

        return currentAssertion
    }

    /// Checks that the function has been called.
    /// - Parameter times: The expected number of calls.
    /// - Parameter assertion: Previous assertion. nil by default.
    /// - Parameter file: File where `called` is called.
    /// - Parameter line: Line where `called`is called.
    /// - Returns: A new `Assertion`.
    /// - Important:
    /// When **assertion** is specify, only calls that appear after
    /// the minimum amount of calls required by the previous assertion will be considered.
    @discardableResult
    public func called(times: Int,
                       after assertion: Assertion? = nil,
                       file: StaticString = #file,
                       line: UInt = #line) -> Assertion {
        called(times: ==times, after: assertion, file: file, line: line)
    }

    /// Checks that the function has never been called.
    /// - Parameter assertion: Previous assertion. nil by default.
    /// - Parameter file: File where `called` is called.
    /// - Parameter line: Line where `called`is called.
    /// - Returns: A new `Assertion`.
    /// - Important:
    /// When **assertion** is specify, only calls that appear after
    /// the minimum amount of calls required by the previous assertion will be considered.
    @discardableResult
    public func neverCalled(after assertion: Assertion? = nil,
                            file: StaticString = #file,
                            line: UInt = #line) -> Assertion {
        called(times: ==0, after: assertion, file: file, line: line)
    }

    /// Checks that the function has been called once.
    /// - Parameter assertion: Previous assertion. nil by default.
    /// - Parameter file: File where `called` is called.
    /// - Parameter line: Line where `called`is called.
    /// - Returns: A new `Assertion`.
    /// - Important:
    /// When **assertion** is specify, only calls that appear after
    /// the minimum amount of calls required by the previous assertion will be considered.
    @discardableResult
    public func calledOnce(after assertion: Assertion? = nil,
                           file: StaticString = #file,
                           line: UInt = #line) -> Assertion {
        called(times: ==1, after: assertion, file: file, line: line)
    }
}
