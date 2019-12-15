//MockThen.swift
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

// MARK: - Global Methods

func then<WrappedType>(_ value: WrappedType,
                       errorHandler: ErrorHandler,
                       file: StaticString,
                       line: UInt) -> MockThen<WrappedType> {
  guard let mock = value as? Mock<WrappedType> else {
    return errorHandler.handle(InternalError.cast(source: value, target: Mock<WrappedType>.self))
  }
  return MockThen(callRegister: mock.callRegister, failureRecorder: XCTestFailureRecorder())
}

// MARK: - Public Global Methods

/// Creates a `MockThen` based on `value`.
/// - Parameter value: Object that will be verified.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Returns: A new `MockThen<WrappedType>` based on `value`.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func then<WrappedType>(_ value: WrappedType,
                              file: StaticString = #file,
                              line: UInt = #line) -> MockThen<WrappedType> {
  then(value, errorHandler: ErrorHandler(), file: file, line: line)
}

/// Call `completion` with a `MockThen` based on `value`.
/// - Parameter value: Object that will be verified.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Parameter completion: Block that will be called.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func then<WrappedType>(_ value: WrappedType,
                              file: StaticString = #file,
                              line: UInt = #line,
                              _ completion: (MockThen<WrappedType>) -> Void) {
  completion(then(value))
}

protocol VerifiableBuilder {
  func verifiable<ReturnType>(
    _ parameters: ParameterType...,
    function: String,
    file: StaticString,
    line: UInt
  ) -> Verifiable<ReturnType>
}

/// MockThen is used to verify method calls.
///
/// To be able to use it on a specific type `CustomType`, you must create an extension.
///
///     extension MockThen where WrappedType == CustomType
///
///
public class MockThen<WrappedType>: VerifiableBuilder {

  // MARK: - Properties

  private let callRegister: CallRegister
  private let failureRecorder: FailureRecorder

  // MARK: - Init

  init(callRegister: CallRegister,
       failureRecorder: FailureRecorder) {
    self.callRegister = callRegister
    self.failureRecorder = failureRecorder
  }

  // MARK: - Public Methods

  /// Creates a `Verifiable` for `function` with `parameters`.
  /// - Parameter parameters: Values that will be used as predicates by the `Verifiable`
  /// for filter method calls.
  /// - Parameter function: Function concerned by the `Verifiable`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `Verifiable<ReturnType>` that will be able to verify `function` calls.
  ///
  /// You must use it during the extension of `MockThen`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) -> Int
  /// }
  /// extension MockThen where WrappedType == CustomType {
  ///   func doSomething(parameter1: Predicate<String>, parameter2: Predicate<Bool>) -> Verifiable<Int> {
  ///     verifiable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The function where you call `verifiable` must respect the following rules:
  ///   - The name must match the function from the `WrappedType`.
  ///       - example: **doSomething(parameter1:parameter2:)**
  ///   - The return type must be a `Verifiable` with, as generic type, the same type
  ///   as the return type of the method in the `WrappedType`. In the example above, `Int` became `Verifiable<Int>`.
  ///   - Call `verifiable` with all parameters in the same order.
  public func verifiable<ReturnType>(
    _ parameters: ParameterType...,
    function: String = #function,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Verifiable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return Verifiable(callRegister: callRegister,
                      functionIdentifier: FunctionIdentifier(function: function, return: ReturnType.self),
                      parametersPredicates: predicates,
                      failureRecorder: failureRecorder)
  }

  public func verifiable<ReturnType>(property: String = #function,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> VerifiableProperty.Readable<ReturnType> {
    VerifiableProperty.Readable(property: property, file: file, line: line, verifiableBuilder: self)
  }

  public func verifiable<ReturnType>(property: String = #function,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> VerifiableProperty.Writable<ReturnType> {
    VerifiableProperty.Writable(property: property, file: file, line: line, verifiableBuilder: self)
  }
}
