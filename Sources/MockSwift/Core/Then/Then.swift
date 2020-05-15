// Then.swift
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
                       failureRecorder: FailureRecorder,
                       file: StaticString,
                       line: UInt) -> Then<WrappedType> {
  guard let mock = value as? Mock<WrappedType> else {
    return errorHandler.handle(InternalError.cast(source: value, target: Mock<WrappedType>.self))
  }
  return Then(callRegister: mock, failureRecorder: failureRecorder)
}

// MARK: - Public Global Methods

/// Creates a `Then` based on `value`.
/// - Parameter value: Object that will be verified.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Returns: A new `Then<WrappedType>` based on `value`.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func then<WrappedType>(_ value: WrappedType,
                              file: StaticString = #file,
                              line: UInt = #line) -> Then<WrappedType> {
  then(value, errorHandler: ErrorHandler(), failureRecorder: XCTestFailureRecorder(), file: file, line: line)
}

/// Call `completion` with a `Then` based on `value`.
/// - Parameter value: Object that will be verified.
/// - Parameter file: The file name where the method is called.
/// - Parameter line: The line where the method is called.
/// - Parameter completion: Block that will be called.
/// - Important: If `value` cannot be cast to `Mock<WrappedType>` a `fatalError` will be raised.
public func then<WrappedType>(_ value: WrappedType,
                              file: StaticString = #file,
                              line: UInt = #line,
                              _ completion: (Then<WrappedType>) -> Void) {
  completion(then(value))
}

/// Then is used to verify method calls.
///
/// To be able to use it on a specific type `CustomType`, you must create an extension.
///
///     extension Then where WrappedType == CustomType
///
///
/// - SeeAlso: `Interaction`
public class Then<WrappedType> {
  // MARK: - Properties

  private let callRegister: CallRegister
  private let failureRecorder: FailureRecorder

  // MARK: - Init

  init(callRegister: CallRegister, failureRecorder: FailureRecorder) {
    self.callRegister = callRegister
    self.failureRecorder = failureRecorder
  }
}

// MARK: - VerifiableBuilder

protocol VerifiableBuilder {
  func verifiable<ReturnType>(_ parameters: ParameterType...,
                              function: String,
                              file: StaticString,
                              line: UInt) -> Verifiable<ReturnType>

  func verifiable<ReturnType>(predicates: [AnyPredicate],
                              function: String,
                              file: StaticString,
                              line: UInt) -> Verifiable<ReturnType>
}

extension Then: VerifiableBuilder {
  // MARK: - Public Methods

  /// Creates a `Verifiable` for `function` with `parameters`.
  /// - Parameter parameters: Values that will be used as predicates by the `Verifiable`
  /// for filter method calls.
  /// - Parameter function: Function concerned by the `Verifiable`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `Verifiable<ReturnType>` that will be able to verify `function` calls.
  ///
  /// You must use it during the extension of `Then`.
  /// ```swift
  /// protocol CustomType {
  ///   func doSomething(parameter1: String, parameter2: Bool) -> Int
  /// }
  /// extension Then where WrappedType == CustomType {
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
  public func verifiable<ReturnType>(_ parameters: ParameterType...,
                                     function: String = #function,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> Verifiable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return verifiable(predicates: predicates, function: function, file: file, line: line)
  }

  func verifiable<ReturnType>(predicates: [AnyPredicate],
                              function: String,
                              file: StaticString,
                              line: UInt) -> Verifiable<ReturnType> {
    Verifiable(callRegister: callRegister,
               functionIdentifier: FunctionIdentifier(function: function, return: ReturnType.self),
               parametersPredicates: predicates,
               failureRecorder: failureRecorder)
  }
}

// MARK: - VerifiablePropertyBuilder

protocol VerifiablePropertyBuilder {
  func verifiable<ReturnType>(property: String,
                              file: StaticString,
                              line: UInt) -> VerifiableProperty.Readable<ReturnType>

  func verifiable<ReturnType>(property: String,
                              file: StaticString,
                              line: UInt) -> VerifiableProperty.Writable<ReturnType>
}

extension Then: VerifiablePropertyBuilder {
  // MARK: - Public Methods

  /// Creates a `VerifiableProperty.Readable` for `property`.
  /// - Parameter property: Property concerned by the `VerifiableProperty`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `VerifiableProperty.Readable<ReturnType>` that will be able to verify `property` calls.
  ///
  /// You must use it during the extension of `Then`.
  /// ```swift
  /// protocol CustomType {
  ///   var variable: Int { get }
  /// }
  /// extension Then where WrappedType == CustomType {
  ///   var variable: VerifiableProperty.Readable<Int>
  ///     verifiable()
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The property where you call `verifiable` must respect the following rules:
  ///   - The name must match the property from the `WrappedType`.
  ///       - example: **variable**
  ///   - The return type must be a `Verifiable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `VerifiableProperty.Readable<Int>`.
  public func verifiable<ReturnType>(property: String = #function,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> VerifiableProperty.Readable<ReturnType> {
    VerifiableProperty.Readable(property: property,
                                file: file,
                                line: line,
                                verifiableBuilder: self)
  }

  /// Creates a `VerifiableProperty.Writable` for `property`.
  /// - Parameter property: Property concerned by the `VerifiableProperty`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `VerifiableProperty.Writable<ReturnType>` that will be able to verify `property` calls.
  ///
  /// You must use it during the extension of `Then`.
  /// ```swift
  /// protocol CustomType {
  ///   var variable: Int { get set }
  /// }
  /// extension Then where WrappedType == CustomType {
  ///   var variable: VerifiableProperty.Writable<Int>
  ///     verifiable()
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The property where you call `verifiable` must respect the following rules:
  ///   - The name must match the property from the `WrappedType`.
  ///       - example: **variable**
  ///   - The return type must be a `Verifiable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `VerifiableProperty.Writable<Int>`.
  public func verifiable<ReturnType>(property: String = #function,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> VerifiableProperty.Writable<ReturnType> {
    VerifiableProperty.Writable(property: property,
                                file: file,
                                line: line,
                                verifiableBuilder: self)
  }
}

// MARK: - VerifiableSubscriptBuilder

protocol VerifiableSubscriptBuilder {
  func verifiable<ReturnType>(_ parameters: ParameterType...,
                              function: String,
                              file: StaticString,
                              line: UInt) -> VerifiableSubscript.Readable<ReturnType>

  func verifiable<ReturnType>(_ parameters: ParameterType...,
                              function: String,
                              file: StaticString,
                              line: UInt) -> VerifiableSubscript.Writable<ReturnType>
}

extension Then: VerifiableSubscriptBuilder {
  // MARK: - Public Methods

  /// Creates a `VerifiableSubscript.Readable` for  a subscript.
  /// - Parameter function: Function concerned by the `VerifiableSubscript`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `VerifiableSubscript.Readable<ReturnType>` that will be able to verify the subscript calls.
  ///
  /// You must use it during the extension of `Then`.
  /// ```swift
  /// protocol CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> Int { get }
  /// }
  /// extension Then where WrappedType == CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> VerifiableSubscript.Readable<Int> {
  ///     verifiable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The subscript where you call `verifiable` must respect the following rules:
  ///   - The name must match the subscript from the `WrappedType`.
  ///       - example: **subcript(parameter1:parameter2)**
  ///   - The return type must be a `VerifiableSubscript.Readable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `VerifiableSubscript.Readable<Int>`.
  public func verifiable<ReturnType>(_ parameters: ParameterType...,
                                     function: String = #function,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> VerifiableSubscript.Readable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return VerifiableSubscript.Readable(function: function,
                                        file: file,
                                        line: line,
                                        verifiableBuilder: self,
                                        predicates: predicates)
  }

  /// Creates a `VerifiableSubscript.Writable` for  a subscript.
  /// - Parameter function: Function concerned by the `VerifiableSubscript`.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A new `VerifiableSubscript.Writable<ReturnType>` that will be able to verify the subscript calls.
  ///
  /// You must use it during the extension of `Then`.
  /// ```swift
  /// protocol CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> Int { get set }
  /// }
  /// extension Then where WrappedType == CustomType {
  ///   subscript(parameter1: String, parameter2: Int) -> VerifiableSubscript.Writable<Int> {
  ///     verifiable(parameter1, parameter2)
  ///   }
  /// }
  /// ```
  /// - Important:
  /// The subscript where you call `verifiable` must respect the following rules:
  ///   - The name must match the subscript from the `WrappedType`.
  ///       - example: **subcript(parameter1:parameter2)**
  ///   - The return type must be a `VerifiableSubscript.Writable` with, as generic type, the same type
  ///   as the return type of the property in the `WrappedType`.
  ///   In the example above, `Int` became `VerifiableSubscript.Writable<Int>`.
  public func verifiable<ReturnType>(_ parameters: ParameterType...,
                                     function: String = #function,
                                     file: StaticString = #file,
                                     line: UInt = #line) -> VerifiableSubscript.Writable<ReturnType> {
    let predicates = parameters.compactMap {
      Predicate<ParameterType>.match($0, file: file, line: line)
    }
    return VerifiableSubscript.Writable(function: function,
                                        file: file,
                                        line: line,
                                        verifiableBuilder: self,
                                        predicates: predicates)
  }
}
