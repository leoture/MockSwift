//MockableSubscript.swift
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

/// Represents a subcript call that can be stubbed.
public class MockableSubscript {

  // MARK: - Properties

  private let mockableBuilder: MockableBuilder
  private let function: String
  private let file: StaticString
  private let line: UInt
  private let predicates: [AnyPredicate]

  // MARK: - Init

  init(function: String, file: StaticString, line: UInt, mockableBuilder: MockableBuilder, predicates: [AnyPredicate]) {
    self.function = function
    self.file = file
    self.line = line
    self.mockableBuilder = mockableBuilder
    self.predicates = predicates
  }
}

extension MockableSubscript {

  // MARK: - Public Methods

  /// Represents a subcript call that returns `ReturnType` and can be stubbed with read access only.
  public class Readable<ReturnType>: MockableSubscript {

    /// Creates a `Mockable` for `get` method of the concerned subcript.
    public var get: Mockable<ReturnType> {
      mockableBuilder.mockable(predicates: predicates, function: function, file: file, line: line)
    }
  }

  /// Represents a subcript call that returns `ReturnType` and can be stubbed with read and wirte access.
  public class Writable<ReturnType>: MockableSubscript {

    /// Creates a `Mockable` for `get` method of the concerned subcript.
    public var get: Mockable<ReturnType> {
      mockableBuilder.mockable(predicates: predicates, function: function, file: file, line: line)
    }

    /// Creates a `Mockable` for `set` method of the concerned subcript.
    /// - Parameter predicate: Value that will be used as predicate by the `Mockable`
    /// to determine if it can handle the call.
    /// - Returns: A new `Mockable<Void>` that will be able to create stubs for `set`method.
    public func set(_ predicate: Predicate<ReturnType>) -> Mockable<Void> {
      var predicates: [AnyPredicate] = self.predicates
      predicates.append(predicate)
      return mockableBuilder.mockable(predicates: predicates, function: function, file: file, line: line)
    }

    /// Creates a `Mockable` for `set` method of the concerned subcript.
    /// - Parameter value: Value that will be used as predicate by the `Mockable`
    /// to determine if it can handle the call.
    /// - Returns: A new `Mockable<Void>` that will be able to create stubs for `set`method.
    public func set(_ value: ReturnType, file: StaticString = #file, line: UInt = #line) -> Mockable<Void> {
      var predicates: [AnyPredicate] = self.predicates
      predicates.append(Predicate<ReturnType>.match(value, file: file, line: line))
      return mockableBuilder.mockable(predicates: predicates, function: function, file: self.file, line: self.line)
    }
  }
}
