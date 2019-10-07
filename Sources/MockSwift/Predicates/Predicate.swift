//Predicate.swift
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

/// Predicate represents a condition on an `Input`.
public class Predicate<Input> {

  // MARK: - Properties

  /// Description of  the Predicate.
  public var description: String

  private let predicate: (Input) -> Bool

  // MARK: - Init

  private init(description: String, predicate: @escaping (Input) -> Bool) {
    self.description = description
    self.predicate = predicate
  }

  // MARK: - Public Methods

  /// Creates a `Predicate<Input>`.
  /// - Parameter description: The description of the Predicate.
  /// - Parameter predicate: The block that will be used to verify that the entry statisfies the Predicate.
  /// - Returns: A new `Predicate<Input>`.
  public class func match(description: String = "custom matcher",
                          _ predicate: @escaping (Input) -> Bool) -> Predicate<Input> {
    Predicate(description: description, predicate: predicate)
  }

  /// Creates a `AnyPredicate`.
  /// - Parameter value: The value to match.
  /// - Parameter file: The file name where the method is called.
  /// - Parameter line: The line where the method is called.
  /// - Returns: A `AnyPredicate` able to match `value`.
  /// - Important: If value cannot be cast to `AnyPredicate` or to `AnyObject` a `fatalError` will be raised.
  public class func match(_ value: Input,
                          file: StaticString = #file,
                          line: UInt = #line) -> AnyPredicate {
    switch value {
    case let value as AnyPredicate: return value
    case let value as AnyObject: return Predicate<AnyObject>.match(description: "\(value)") { $0 === value }
    default: fatalError("\(value) cannot be cast to \(AnyPredicate.self) or \(AnyObject.self)", file: file, line: line)
    }
  }

  /// Creates a `Predicate<Input>` able to match any value of type `Input`.
  public class func any() -> Predicate<Input> {
    .match(description: "any") { _ in true }
  }

  /// Creates a `Predicate<Input>` able to match any value of type `Input` not matched by an other predicate.
  /// - Parameter predicate: The predicate to not match.
  /// - Returns: A new `Predicate<Input>`.
  public class func not(_ predicate: Predicate<Input>) -> Predicate<Input> {
    .match(description: "not \(predicate)") { !predicate.satisfy(by: $0) }
  }

}

// MARK: - AnyPredicate

extension Predicate: AnyPredicate {

  /// Check if an `element` satifies the predicate.
  /// - Parameter element: The element to check.
  /// - Returns: True if `element` is of type `Input` and satisfies the predicate, false otherwise.
  /// - SeeAlso: `AnyPredicate`
  public func satisfy(by element: Any?) -> Bool {
    guard let element = element as? Input else {
      return false
    }
    return predicate(element)
  }
}
