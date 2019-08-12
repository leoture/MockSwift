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

public class Predicate<Input>: AnyPredicate {
  public class func match(_ predicate: @escaping (Input) -> Bool) -> Predicate<Input> {
    Predicate(predicate)
  }

  public class var any: Predicate<Input> {
    Self.match { _ in true }
  }

  private let predicate: (Input) -> Bool

  private init(_ predicate: @escaping (Input) -> Bool) {
    self.predicate = predicate
  }

  public func satisfy(by element: Any) -> Bool {
    guard let element = element as? Input else {
      return false
    }
    return predicate(element)
  }
}
