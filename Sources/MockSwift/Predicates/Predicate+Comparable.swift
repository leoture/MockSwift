//Predicate+Comparable.swift
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
/// Creates a `Predicate<Input>` that can match any elements equal to `rhs`
/// - Parameter rhs: The element to compare to.
/// - SeeAlso: `Predicate`
public prefix func ==<Input: Equatable>(rhs: Input) -> Predicate<Input> { .equalsTo(rhs: rhs) }

public extension Predicate where Input: Equatable {

  /// Creates a `Predicate<Input>` that can match any elements equal to `rhs`
  /// - Parameter rhs: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func equalsTo(rhs: Input) -> Predicate<Input> {
    Predicate.match(description: "\(rhs)") { $0 == rhs }
  }
}

prefix operator >
/// Creates a `Predicate<Input>` that can match any elements greater than `rhs`
/// - Parameter rhs: The element to compare to.
/// - SeeAlso: `Predicate`
public prefix func ><Input: Comparable>(rhs: Input) -> Predicate<Input> {
  .greaterThan(rhs: rhs)
}

prefix operator >=
/// Creates a `Predicate<Input>` that can match any elements greater than or equal to `rhs`
/// - Parameter rhs: The element to compare to.
/// - SeeAlso: `Predicate`
public prefix func >=<Input: Comparable>(rhs: Input) -> Predicate<Input> {
  .greaterThanOrEqualsTo(rhs: rhs)
}

public extension Predicate where Input: Comparable {
  /// Creates a `Predicate<Input>` that can match any elements greater than `rhs`
  /// - Parameter rhs: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func greaterThan(rhs: Input) -> Predicate<Input> {
    Predicate.match(description: "greater than \(rhs)") { $0 > rhs }
  }

  /// Creates a `Predicate<Input>` that can match any elements greater than or equal to `rhs`
  /// - Parameter rhs: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func greaterThanOrEqualsTo(rhs: Input) -> Predicate<Input> {
    Predicate.match(description: "greater than or equals to \(rhs)") { $0 >= rhs }
  }

  /// Creates a `Predicate<Input>` that can match any elements less than `rhs`
  /// - Parameter rhs: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func lessThan(rhs: Input) -> Predicate<Input> {
    Predicate.match(description: "less than \(rhs)") { $0 < rhs }
  }

  /// Creates a `Predicate<Input>` that can match any elements less than or equal to `rhs`
  /// - Parameter rhs: The element to compare to.
  /// - SeeAlso: `Predicate`
  static func lessThanOrEqualsTo(rhs: Input) -> Predicate<Input> {
    Predicate.match(description: "less than or equals to \(rhs)") { $0 <= rhs }
  }
}
