// Given.swift
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

func given<WrappedType>(_ value: WrappedType,
                        errorHandler: ErrorHandler,
                        file: StaticString,
                        line: UInt) -> Given<WrappedType> {
  guard let mock = value as? Mock<WrappedType> else {
    return errorHandler.handle(InternalError.cast(source: value, target: Mock<WrappedType>.self))
  }
  return Given(mock)
}

// MARK: - Public Global Methods

/// Creates a `Given` based on `value`.
/// - Parameter value: Object that will be stubbed.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Returns: A new `Given<WrappedType>` based on `value`.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func given<WrappedType>(_ value: WrappedType,
                               file: StaticString = #file,
                               line: UInt = #line) -> Given<WrappedType> {
  given(value, errorHandler: ErrorHandler(), file: file, line: line)
}

/// Call `completion` with  a `Given` based on `value`.
/// - Parameter value: Object that will be stubbed.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Parameter completion: Block where to define behaviours.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func given<WrappedType>(_ value: WrappedType,
                               file: StaticString = #file,
                               line: UInt = #line,
                               _ completion: (Given<WrappedType>) -> Void) {
  completion(given(value, file: file, line: line))
}

/// Given is used to define behaviours.
///
/// To be able to use it on a specific type `CustomType`, you must create an extension.
///
///     extension Given where WrappedType == CustomType
///
///
public class Given<WrappedType> {
  // MARK: - Properties

  private let behaviourRegister: BehaviourRegister

  // MARK: - Init

  fileprivate init(_ behaviourRegister: BehaviourRegister) {
    self.behaviourRegister = behaviourRegister
  }
}

// MARK: - MockableBuilder

protocol MockableBuilder {
  func mockable<ReturnType>(_ parameters: ParameterType...,
                            function: String,
                            file: StaticString,
                            line: UInt) -> Mockable<ReturnType>

  func mockable<ReturnType>(predicates: [AnyPredicate],
                            function: String,
                            file: StaticString,
                            line: UInt) -> Mockable<ReturnType>
}

extension Given: MockableBuilder {
  // MARK: - Public Methods

  /// Creates a `Mockable` for `function` with `parameters`.
  /// - Parameter parameters: Values that will be used as predicates by the `Mockable`
  /// to determine if it can handle the call.
  /// - Parameter function: Function concerned by the `Mockable`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `Mockable<ReturnType>` that will be able to create stubs for `function`.
  ///
  /// You must use it during the extension of `Given`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) -> Int
  /// }
  /// extension Given where WrappedType == CustomType {
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
  public func mockable<ReturnType>(_ parameters: ParameterType...,
                                   function: String = #function,
                                   file: StaticString = #file,
                                   line: UInt = #line) -> Mockable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return mockable(predicates: predicates, function: function, file: file, line: line)
  }

  func mockable<ReturnType>(predicates: [AnyPredicate],
                            function: String,
                            file: StaticString,
                            line: UInt) -> Mockable<ReturnType> {
    Mockable(behaviourRegister, FunctionIdentifier(function: function, return: ReturnType.self), predicates)
  }
}

// MARK: - MockablePropertyBuilder

protocol MockablePropertyBuilder {
  func mockable<ReturnType>(property: String, file: StaticString, line: UInt) -> MockableProperty.Readable<ReturnType>
  func mockable<ReturnType>(property: String, file: StaticString, line: UInt) -> MockableProperty.Writable<ReturnType>
}

extension Given: MockablePropertyBuilder {
  // MARK: - Public Methods

  /// Creates a `MockableProperty.Readable` for `property`.
  /// - Parameter property: Property concerned by the `MockableProperty`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `MockableProperty.Readable<ReturnType>` that will be able to create stubs for `property`.
  ///
  /// You must use it during the extension of `Given`.
  /// ```swift
  /// protocol CustomType {
  ///   var variable: Int { get }
  /// }
  /// extension Given where WrappedType == CustomType {
  ///   var variable: MockableProperty.Readable<Int> {
  ///     mockable()
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The property where you call `mockable` must respect the following rules:
  ///   - The name must match the property from the `WrappedType`.
  ///       - example: **variable**
  ///   - The return type must be a `MockableProperty.Readable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `MockableProperty.Readable<Int>`.
  public func mockable<ReturnType>(property: String = #function,
                                   file: StaticString = #file,
                                   line: UInt = #line) -> MockableProperty.Readable<ReturnType> {
    MockableProperty.Readable(property: property,
                              file: file,
                              line: line,
                              mockableBuilder: self)
  }

  /// Creates a `MockableProperty.Writable` for `property`.
  /// - Parameter property: Property concerned by the `MockableProperty`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `MockableProperty.Writable<ReturnType>` that will be able to create stubs for `property`.
  ///
  /// You must use it during the extension of `Given`.
  /// ```swift
  /// protocol CustomType {
  ///   var variable: Int { get set }
  /// }
  /// extension Given where WrappedType == CustomType {
  ///   var variable: MockableProperty.Writable<Int> {
  ///     mockable()
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The property where you call `mockable` must respect the following rules:
  ///   - The name must match the property from the `WrappedType`.
  ///       - example: **variable**
  ///   - The return type must be a `MockableProperty.Writable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `MockableProperty.Writable<Int>`.
  public func mockable<ReturnType>(property: String = #function,
                                   file: StaticString = #file,
                                   line: UInt = #line) -> MockableProperty.Writable<ReturnType> {
    MockableProperty.Writable(property: property,
                              file: file,
                              line: line,
                              mockableBuilder: self)
  }
}

// MARK: - MockableSubscriptBuilder

protocol MockableSubscriptBuilder {
  func mockable<ReturnType>(_ parameters: ParameterType...,
                            function: String,
                            file: StaticString,
                            line: UInt) -> MockableSubscript.Readable<ReturnType>

  func mockable<ReturnType>(_ parameters: ParameterType...,
                            function: String,
                            file: StaticString,
                            line: UInt) -> MockableSubscript.Writable<ReturnType>
}

extension Given: MockableSubscriptBuilder {
  // MARK: - Public Methods

  /// Creates a `MockableSubscript.Readable` for a subcript.
  /// - Parameter function: Function concerned by the `MockableSubscript`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `MockableSubscript.Readable<ReturnType>` that will be able to create stubs for the subcript.
  ///
  /// You must use it during the extension of `Given`.
  /// ```swift
  /// protocol CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> Int { get }
  /// }
  /// extension Given where WrappedType == CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> MockableSubscript.Readable<Int> {
  ///     mockable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The subcript where you call `mockable` must respect the following rules:
  ///   - The name must match the subcript from the `WrappedType`.
  ///       - example: **subcript(parameter1:parameter2)**
  ///   - The return type must be a `MockableSubscript.Readable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `MockableSubscript.Readable<Int>`.
  public func mockable<ReturnType>(_ parameters: ParameterType...,
                                   function: String = #function,
                                   file: StaticString = #file,
                                   line: UInt = #line) -> MockableSubscript.Readable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return MockableSubscript.Readable(function: function,
                                      file: file,
                                      line: line,
                                      mockableBuilder: self,
                                      predicates: predicates)
  }

  /// Creates a `MockableSubscript.Writable` for a subcript.
  /// - Parameter function: Function concerned by the `MockableSubscript`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `MockableSubscript.Writable<ReturnType>` that will be able to create stubs for the subcript.
  ///
  /// You must use it during the extension of `Given`.
  /// ```swift
  /// protocol CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> Int { get set }
  /// }
  /// extension Given where WrappedType == CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> MockableSubscript.Writable<Int> {
  ///     mockable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The subcript where you call `mockable` must respect the following rules:
  ///   - The name must match the subcript from the `WrappedType`.
  ///       - example: **subcript(parameter1:parameter2)**
  ///   - The return type must be a `MockableSubscript.Writable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `MockableSubscript.Writable<Int>`.
  public func mockable<ReturnType>(_ parameters: ParameterType...,
                                   function: String = #function,
                                   file: StaticString = #file,
                                   line: UInt = #line) -> MockableSubscript.Writable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return MockableSubscript.Writable(function: function,
                                      file: file,
                                      line: line,
                                      mockableBuilder: self,
                                      predicates: predicates)
  }
}
