// Predicate+Comparable.swift
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

prefix operator ==
/// Creates a `Predicate<Input>` that can match any elements equal to `value`
/// - Parameter value: The element to compare to.
/// - SeeAlso: `Predicate`
public prefix func == <Input: Equatable>(value: Input) -> Predicate<Input> { .equals(to: value) }

public extension Predicate where Input: Equatable {
  /// Creates a `Predicate<Input>` that can match any elements equal to `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func equals(to value: Input) -> Predicate<Input> {
    Predicate.match(description: "\(value)") { $0 == value }
  }

  /// Creates a `Predicate<Input>` that can match any elements equal to `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func eq(_ value: Input) -> Predicate<Input> {
    .equals(to: value)
  }
}

prefix operator >
/// Creates a `Predicate<Input>` that can match any elements greater than `value`
/// - Parameter value: The element to compare to.
/// - SeeAlso: `Predicate`
public prefix func > <Input: Comparable>(value: Input) -> Predicate<Input> {
  .greater(than: value)
}

prefix operator >=
/// Creates a `Predicate<Input>` that can match any elements greater than or equal to `value`
/// - Parameter value: The element to compare to.
/// - SeeAlso: `Predicate`
public prefix func >= <Input: Comparable>(value: Input) -> Predicate<Input> {
  .greaterThanOrEquals(to: value)
}

public extension Predicate where Input: Comparable {
  /// Creates a `Predicate<Input>` that can match any elements greater than `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func greater(than value: Input) -> Predicate<Input> {
    Predicate.match(description: "greater than \(value)") { $0 > value }
  }

  /// Creates a `Predicate<Input>` that can match any elements greater than `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func gt(_ value: Input) -> Predicate<Input> {
    .greater(than: value)
  }

  /// Creates a `Predicate<Input>` that can match any elements greater than or equal to `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func greaterThanOrEquals(to value: Input) -> Predicate<Input> {
    Predicate.match(description: "greater than or equals to \(value)") { $0 >= value }
  }

  /// Creates a `Predicate<Input>` that can match any elements greater than or equal to `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func ge(_ value: Input) -> Predicate<Input> {
    .greaterThanOrEquals(to: value)
  }

  /// Creates a `Predicate<Input>` that can match any elements less than `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func less(than value: Input) -> Predicate<Input> {
    Predicate.match(description: "less than \(value)") { $0 < value }
  }

  /// Creates a `Predicate<Input>` that can match any elements less than `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func lt(_ value: Input) -> Predicate<Input> {
    .less(than: value)
  }

  /// Creates a `Predicate<Input>` that can match any elements less than or equal to `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func lessThanOrEquals(to value: Input) -> Predicate<Input> {
    Predicate.match(description: "less than or equals to \(value)") { $0 <= value }
  }

  /// Creates a `Predicate<Input>` that can match any elements less than or equal to `value`
  /// - Parameter value: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func le(_ value: Input) -> Predicate<Input> {
    .lessThanOrEquals(to: value)
  }
}
