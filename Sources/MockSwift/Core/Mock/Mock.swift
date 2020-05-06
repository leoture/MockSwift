// Mock.swift
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

  private let strategy: Strategy
  private let errorHandler: ErrorHandler
  private let callRegister: CallRegister
  private let behaviourRegister: BehaviourRegister
  private let stubRegister: StubRegister

  /// Returns `self` as a `WrappedType`.
  /// - Important: If `self` cannot be cast to `WrappedType` a `fatalError` will be raised.
  public var wrappedValue: WrappedType {
    guard let value = self as? WrappedType else {
      return errorHandler.handle(.cast(source: self, target: WrappedType.self))
    }
    return value
  }

  // MARK: - Init

  required init(callRegister: CallRegister,
                behaviourRegister: BehaviourRegister,
                stubRegister: StubRegister,
                strategy: Strategy,
                errorHandler: ErrorHandler) {
    self.callRegister = callRegister
    self.behaviourRegister = behaviourRegister
    self.stubRegister = stubRegister
    self.strategy = strategy
    self.errorHandler = errorHandler
  }

  convenience init(callRegister: CallRegister,
                   behaviourRegister: BehaviourRegister,
                   stubRegister: StubRegister,
                   factory: StrategyFactory,
                   strategies: [StrategyIdentifier],
                   errorHandler: ErrorHandler) {
    self.init(callRegister: FunctionCallRegister(),
              behaviourRegister: behaviourRegister,
              stubRegister: stubRegister,
              strategy: factory.create(strategy: strategies),
              errorHandler: errorHandler)
  }

  convenience init(strategies: [StrategyIdentifier]) {
    let errorHandler = ErrorHandler()
    let behaviourRegister = FunctionBehaviourRegister()
    let stubRegister = StubTypeRegister()
    self.init(callRegister: FunctionCallRegister(),
              behaviourRegister: behaviourRegister,
              stubRegister: stubRegister,
              factory: MockStrategyFactory(errorHandler: errorHandler,
                                           behaviourRegister: behaviourRegister,
                                           stubRegister: stubRegister),
              strategies: strategies,
              errorHandler: errorHandler)
  }

  /// Creates a `Mock<WrappedType>`.
  public convenience init() {
    self.init(strategies: .default)
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
    strategy.resolve(for: function, concernedBy: parameters)
  }

  private func callThrowable<ReturnType>(function: FunctionIdentifier,
                                         with parameters: [ParameterType]) throws -> ReturnType {
    try strategy.resolveThrowable(for: function, concernedBy: parameters)
  }
}

// MARK: - CallRegister

extension Mock: CallRegister {
  var isEmpty: Bool {
    callRegister.isEmpty
  }

  func recordCall(for identifier: FunctionIdentifier, with parameters: [ParameterType]) {
    callRegister.recordCall(for: identifier, with: parameters)
  }

  func recordedCall(for identifier: FunctionIdentifier, when matchs: [AnyPredicate]) -> [FunctionCall] {
    callRegister.recordedCall(for: identifier, when: matchs)
  }
}

// MARK: - BehaviourRegister

extension Mock: BehaviourRegister {
  func recordedBehaviours(for identifier: FunctionIdentifier, concernedBy parameters: [ParameterType]) -> [Behaviour] {
    behaviourRegister.recordedBehaviours(for: identifier, concernedBy: parameters)
  }

  func record(_ behaviour: Behaviour, for identifier: FunctionIdentifier, when matchs: [AnyPredicate]) {
    behaviourRegister.record(behaviour, for: identifier, when: matchs)
  }
}

// MARK: - StubRegister

extension Mock: StubRegister {
  func recordedStub<ReturnType>(for returnType: ReturnType.Type) -> ReturnType? {
    stubRegister.recordedStub(for: returnType)
  }

  func record(_ stub: Stub) {
    stubRegister.record(stub)
  }
}
