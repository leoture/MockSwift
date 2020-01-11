//Mock.swift
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

@propertyWrapper
/// `Mock<WrappedType>` is use to define a mock on `WrappedType`.
///
/// To be able to use it on a specific type `CustomType`, you must create an extension.
///
///     extension Mock: CustomType where WrappedType == CustomType
///
///
public class Mock<WrappedType> {

  // MARK: - Properties

  let callRegister: CallRegister
  let behaviourRegister: BehaviourRegister
  let errorHandler: ErrorHandler

  /// Returns `self` as a `WrappedType`.
  /// - Important: If `self` cannot be cast to `WrappedType` a `fatalError` will be raised.
  public var wrappedValue: WrappedType {
    guard let value = self as? WrappedType else {
      return errorHandler.handle(.cast(source: self, target: WrappedType.self))
    }
    return value
  }

  // MARK: - Init

  required init(callRegister: CallRegister, behaviourRegister: BehaviourRegister, errorHandler: ErrorHandler) {
    self.callRegister = callRegister
    self.behaviourRegister = behaviourRegister
    self.errorHandler = errorHandler
  }

  /// Creates a `Mock<WrappedType>`.
  public convenience init() {
    self.init(callRegister: FunctionCallRegister(),
              behaviourRegister: FunctionBehaviourRegister(),
              errorHandler: ErrorHandler())
  }

  // MARK: - Public Methods

  /// Records the `function` call with `parameters` and executes the predefined behavior.
  /// - Parameter parameters: Values passed to `function`.
  /// - Parameter function: Function where `mocked` is called.
  ///
  /// You must use it during the extension of `Mock`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool)
  /// }
  /// extension Mock: CustomType where WrappedType == CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) {
  ///     mocked(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The function where you call `mocked` must respect the following rules:
  ///   - The function must be defined in `WrappedType`.
  ///       - example: **doSomething(parameter1:parameter2:)**
  ///   - Call `mocked` with all parameters in the same order.
  /// Exactly one behaviour must match the call, otherwise a `fatalError` will be raised.
  public func mocked(_ parameters: ParameterType..., function: String = #function) {
    let identifier = FunctionIdentifier(function: function, return: Void.self)
    willCall(function: identifier, with: parameters)
    return call(function: identifier, with: parameters)
  }

  /// Records the `function` call with `parameters` and executes the predefined behavior.
  /// - Parameter parameters: Values passed to `function`.
  /// - Parameter function: Function where `mockedThrowable` is called.
  ///
  /// You must use it during the extension of `Mock`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) throws
  /// }
  /// extension Mock: CustomType where WrappedType == CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) throws {
  ///     try mockedThrowable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The function where you call `mockedThrowable` must respect the following rules:
  ///   - The function must be defined in `WrappedType`.
  ///       - example: **doSomething(parameter1:parameter2:)**
  ///   - Call `mockedThrowable` with all parameters in the same order.
  /// Exactly one behaviour must match the call, otherwise a `fatalError` will be raised.
  public func mockedThrowable(_ parameters: ParameterType..., function: String = #function) throws {
    let identifier = FunctionIdentifier(function: function, return: Void.self)
    willCall(function: identifier, with: parameters)
    return try callThrowable(function: identifier, with: parameters)
  }

  /// Records the `function` call with `parameters` and executes the predefined behavior.
  /// - Parameter parameters: Values passed to `function`.
  /// - Parameter function: Function where `mocked` is called.
  /// - Returns: The value computed by the behavior that match the call.
  ///
  /// You must use it during the extension of `Mock`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) -> Int
  /// }
  /// extension Mock: CustomType where WrappedType == CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) -> Int {
  ///     mocked(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The function where you call `mocked` must respect the following rules:
  ///   - The function must be defined in `WrappedType`.
  ///       - example: **doSomething(parameter1:parameter2:)**
  ///   - Call `mocked` with all parameters in the same order.
  /// Exactly one behaviour must match the call, otherwise a `fatalError` will be raised.
  public func mocked<ReturnType>(_ parameters: ParameterType..., function: String = #function) -> ReturnType {
    let identifier = FunctionIdentifier(function: function, return: ReturnType.self)
    willCall(function: identifier, with: parameters)
    return call(function: identifier, with: parameters)
  }

  /// Records the `function` call with `parameters` and executes the predefined behavior.
  /// - Parameter parameters: Values passed to `function`.
  /// - Parameter function: Function where `mockedThrowable` is called.
  /// - Returns: The value computed by the behavior that match the call.
  ///
  /// You must use it during the extension of `Mock`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) throws -> Int
  /// }
  /// extension Mock: CustomType where WrappedType == CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) throws -> Int {
  ///     try mockedThrowable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The function where you call `mockedThrowable` must respect the following rules:
  ///   - The function must be defined in `WrappedType`.
  ///       - example: **doSomething(parameter1:parameter2:)**
  ///   - Call `mockedThrowable` with all parameters in the same order.
  /// Exactly one behaviour must match the call, otherwise a `fatalError` will be raised.
  public func mockedThrowable<ReturnType>(_ parameters: ParameterType...,
                                          function: String = #function) throws -> ReturnType {
    let identifier = FunctionIdentifier(function: function, return: ReturnType.self)
    willCall(function: identifier, with: parameters)
    return try callThrowable(function: identifier, with: parameters)
  }

  // MARK: - Private Methods

  private func willCall(function: FunctionIdentifier, with parameters: [ParameterType]) {
    callRegister.recordCall(for: function, with: parameters)
  }

  private func call<ReturnType>(function: FunctionIdentifier, with parameters: [ParameterType]) -> ReturnType {
    let behaviours = behaviourRegister.recordedBehaviours(for: function, concernedBy: parameters)

    switch behaviours.count {
    case 1:
      return behaviours[0].handle(with: parameters) ??
             errorHandler.handle(.noDefinedBehaviour(for: function, with: parameters))
    case 0: return errorHandler.handle(.noDefinedBehaviour(for: function, with: parameters))
    default: return errorHandler.handle(.tooManyDefinedBehaviour(for: function, with: parameters))
    }
  }

  private func callThrowable<ReturnType>(function: FunctionIdentifier,
                                         with parameters: [ParameterType]) throws -> ReturnType {
    let behaviours = behaviourRegister.recordedBehaviours(for: function, concernedBy: parameters)

    switch behaviours.count {
    case 1:
      return try behaviours[0].handleThrowable(with: parameters) ??
                 errorHandler.handle(.noDefinedBehaviour(for: function, with: parameters))
    case 0: return errorHandler.handle(.noDefinedBehaviour(for: function, with: parameters))
    default: return errorHandler.handle(.tooManyDefinedBehaviour(for: function, with: parameters))
    }
  }
}
