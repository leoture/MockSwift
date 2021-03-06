// Stub.swift
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

/// Stub represents a paire of type and a value of this type
public class Stub {
  let value: Any
  let returnType: Any

  /// Creates a Stub
  /// - Parameters:
  ///   - returnType: Type to define a stub value
  ///   - value: Stub value
  public init<ReturnType>(_ returnType: ReturnType.Type, _ value: ReturnType) {
    self.returnType = returnType
    self.value = value
  }
}

infix operator =>

/// Creates a Stub
/// - Parameters:
///   - lhs: Type to define a stub value
///   - rhs: Stub value
public func => <ReturnType>(lhs: ReturnType.Type, rhs: ReturnType) -> Stub {
  Stub(lhs, rhs)
}
