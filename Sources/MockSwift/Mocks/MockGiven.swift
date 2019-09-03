//MockGiven.swift
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

/// Creates a `MockGiven` based on `value`.
/// - Parameter value: object that will be stubbed.
/// - Returns: a new `MockGiven<WrappedType>` based on `value`.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func given<WrappedType>(_ value: WrappedType) -> MockGiven<WrappedType> {
  guard let mock = value as? Mock<WrappedType> else {
    fatalError("\(value) cannot be cast to \(Mock<WrappedType>.self)")
  }
  return MockGiven(mock.behaviourRegister)
}

/// MockGiven is used to define stubs.
///
/// To be able to use it on a specific type `CustomType`, you must create an extension.
///
///     extension MockGiven where WrappedType == CustomType
///
///
public class MockGiven<WrappedType> {
  private let behaviourRegister: BehaviourRegister

  fileprivate init(_ behaviourRegister: BehaviourRegister) {
    self.behaviourRegister = behaviourRegister
  }

  /// Creates a `Mockable` for `function` with `parametersPredicates`.
  /// - Parameter parametersPredicates: predicates that will be used by the `Mockable`
  /// to determine if it can handle the call.
  /// - Parameter function: function concerned by the `Mockable`.
  /// - Returns: A new `Mockable<ReturnType>` that will be able to create stubs for `function`.
  ///
  /// You must use it during the extension of `MockGiven`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) -> Int
  /// }
  /// extension MockGiven where WrappedType == CustomType {
  ///   func doSomething(parameter1: Predicate<String>, parameter2: Predicate<Bool>) -> Mockable<Int> {
  ///     mockable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The function where you call `mockable` must respect the following rules:
  ///   - The name must match the function from the `WrappedType`.
  ///       - example: **doSomething(parameter1:parameter2:)**
  ///   - The return type must be a `Mockable` with, as generic type, the same type
  ///   as the return type of the method in the `WrappedType`. In the example above, `Int` became `Mockable<Int>`.
  ///   - Call `mockable` with all parameters in the same order.
  public func mockable<ReturnType>(
    _ parametersPredicates: AnyPredicate...,
    function: String = #function
  ) -> Mockable<ReturnType> {
    Mockable(behaviourRegister, FunctionIdentifier(function: function, return: ReturnType.self), parametersPredicates)
  }
}
