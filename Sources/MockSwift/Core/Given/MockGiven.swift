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

// MARK: - Global Methods

func given<WrappedType>(_ value: WrappedType,
                        errorHandler: ErrorHandler,
                        file: StaticString,
                        line: UInt) -> MockGiven<WrappedType> {
  guard let mock = value as? Mock<WrappedType> else {
    return errorHandler.handle(InternalError.cast(source: value, target: Mock<WrappedType>.self))
  }
  return MockGiven(mock)
}

// MARK: - Public Global Methods

/// Creates a `MockGiven` based on `value`.
/// - Parameter value: Object that will be stubbed.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Returns: A new `MockGiven<WrappedType>` based on `value`.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func given<WrappedType>(_ value: WrappedType,
                               file: StaticString = #file,
                               line: UInt = #line) -> MockGiven<WrappedType> {
  given(value, errorHandler: ErrorHandler(), file: file, line: line)
}

/// Call `completion` with  a `MockGiven` based on `value`.
/// - Parameter value: Object that will be stubbed.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Parameter completion: Block where to define behaviours.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func given<WrappedType>(_ value: WrappedType,
                               file: StaticString = #file,
                               line: UInt = #line,
                               _ completion: (MockGiven<WrappedType>) -> Void) {
  completion(given(value, file: file, line: line))
}

/// MockGiven is used to define behaviours.
///
/// To be able to use it on a specific type `CustomType`, you must create an extension.
///
///     extension MockGiven where WrappedType == CustomType
///
///
public class MockGiven<WrappedType> {

  // MARK: - Properties

  private let behaviourRegister: BehaviourRegister

  // MARK: - Init

  fileprivate init(_ behaviourRegister: BehaviourRegister) {
    self.behaviourRegister = behaviourRegister
  }

}

// MARK: - MockableBuilder

protocol MockableBuilder {
  func mockable<ReturnType>(
    _ parameters: ParameterType...,
    function: String,
    file: StaticString,
    line: UInt
  ) -> Mockable<ReturnType>

  func mockable<ReturnType>(
    predicates: [AnyPredicate],
    function: String,
    file: StaticString,
    line: UInt
  ) -> Mockable<ReturnType>
}

extension MockGiven: MockableBuilder {

  // MARK: - Public Methods

  /// Creates a `Mockable` for `function` with `parameters`.
  /// - Parameter parameters: Values that will be used as predicates by the `Mockable`
  /// to determine if it can handle the call.
  /// - Parameter function: Function concerned by the `Mockable`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
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
    _ parameters: ParameterType...,
    function: String = #function,
    file: StaticString = #file,
    line: UInt = #line
  ) -> Mockable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return mockable(predicates: predicates, function: function, file: file, line: line)
  }

  func mockable<ReturnType>(
    predicates: [AnyPredicate],
    function: String,
    file: StaticString,
    line: UInt
  ) -> Mockable<ReturnType> {
    Mockable(behaviourRegister, FunctionIdentifier(function: function, return: ReturnType.self), predicates)
  }
}

// MARK: - MockablePropertyBuilder

protocol MockablePropertyBuilder {
  func mockable<ReturnType>(
    _ parameters: ParameterType...,
    property: String,
    file: StaticString,
    line: UInt
  ) -> MockableProperty.Readable<ReturnType>

  func mockable<ReturnType>(
    _ parameters: ParameterType...,
    property: String,
    file: StaticString,
    line: UInt) -> MockableProperty.Writable<ReturnType>
}

extension MockGiven: MockablePropertyBuilder {

  // MARK: - Public Methods

  /// Creates a `MockableProperty.Readable` for `property`.
  /// - Parameter property: Property concerned by the `MockableProperty`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `MockableProperty.Readable<ReturnType>` that will be able to create stubs for `property`.
  ///
  /// You must use it during the extension of `MockGiven`.
  /// ```swift
  /// protocol CustomType {
  ///   var variable: Int { get }
  /// }
  /// extension MockGiven where WrappedType == CustomType {
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
  public func mockable<ReturnType>(
    _ parameters: ParameterType...,
    property: String = #function,
    file: StaticString = #file,
    line: UInt = #line) -> MockableProperty.Readable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return MockableProperty.Readable(property: property,
                                     file: file,
                                     line: line,
                                     mockableBuilder: self,
                                     predicates: predicates)
  }

  /// Creates a `MockableProperty.Writable` for `property`.
  /// - Parameter property: Property concerned by the `MockableProperty`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `MockableProperty.Writable<ReturnType>` that will be able to create stubs for `property`.
  ///
  /// You must use it during the extension of `MockGiven`.
  /// ```swift
  /// protocol CustomType {
  ///   var variable: Int { get set }
  /// }
  /// extension MockGiven where WrappedType == CustomType {
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
  public func mockable<ReturnType>(
    _ parameters: ParameterType...,
    property: String = #function,
    file: StaticString = #file,
    line: UInt = #line) -> MockableProperty.Writable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return MockableProperty.Writable(property: property,
                                     file: file,
                                     line: line,
                                     mockableBuilder: self,
                                     predicates: predicates)
  }
}
