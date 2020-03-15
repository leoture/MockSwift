// VerifiableSubscript.swift
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

/// Represents a property call that can be checked.
public class VerifiableSubscript {
  // MARK: - Properties

  private let verifiableBuilder: VerifiableBuilder
  private let function: String
  private let file: StaticString
  private let line: UInt
  private let predicates: [AnyPredicate]

  // MARK: - Init

  init(function: String,
       file: StaticString,
       line: UInt,
       verifiableBuilder: VerifiableBuilder,
       predicates: [AnyPredicate]) {
    self.function = function
    self.file = file
    self.line = line
    self.verifiableBuilder = verifiableBuilder
    self.predicates = predicates
  }
}

extension VerifiableSubscript {
  // MARK: - Public Methods

  /// Represents a property call that returns `ReturnType` and can be checked with read access only.
  public class Readable<ReturnType>: VerifiableSubscript {
    /// Creates a `Verifiable` for `get` method of the concerned property.
    public var get: Verifiable<ReturnType> {
      verifiableBuilder.verifiable(predicates: predicates, function: function, file: file, line: line)
    }
  }

  /// Represents a property call that returns `ReturnType` and can be checked with read and wirte access.
  public class Writable<ReturnType>: VerifiableSubscript {
    /// Creates a `Verifiable` for `get` method of the concerned property.
    public var get: Verifiable<ReturnType> {
      verifiableBuilder.verifiable(predicates: predicates, function: function, file: file, line: line)
    }

    /// Creates a `Verifiable` for `set` method of the concerned property.
    /// - Parameter predicate: Value that will be used as predicate by the `Verifiable`
    /// to determine if it can handle the call.
    /// - Returns: A new `Verifiable<Void>` that will be able to check `set`method calls.
    public func set(_ predicate: Predicate<ReturnType>) -> Verifiable<Void> {
      var predicates: [AnyPredicate] = self.predicates
      predicates.append(predicate)
      return verifiableBuilder.verifiable(predicates: predicates, function: function, file: file, line: line)
    }

    /// Creates a `Verifiable` for `set` method of the concerned property.
    /// - Parameter value: Value that will be used as predicate by the `Verifiable`
    /// to determine if it can handle the call.
    /// - Returns: A new `Verifiable<Void>` that will be able to check `set`method calls.
    public func set(_ value: ReturnType, file: StaticString = #file, line: UInt = #line) -> Verifiable<Void> {
      var predicates: [AnyPredicate] = self.predicates
      predicates.append(Predicate<ReturnType>.match(value, file: file, line: line))
      return verifiableBuilder.verifiable(predicates: predicates, function: function, file: self.file, line: self.line)
    }
  }
}
