//VerifiableProperty.swift
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

public class VerifiableProperty {
  private let verifiableBuilder: VerifiableBuilder
  private let property: String
  private let file: StaticString
  private let line: UInt

  init(property: String, file: StaticString, line: UInt, verifiableBuilder: VerifiableBuilder) {
    self.property = property
    self.file = file
    self.line = line
    self.verifiableBuilder = verifiableBuilder
  }
}

extension VerifiableProperty {
  public class Readable<ReturnType>: VerifiableProperty {
    public var get: Verifiable<ReturnType> {
      verifiableBuilder.verifiable(function: property, file: file, line: line)
    }
  }

  public class Writable<ReturnType>: VerifiableProperty {
    public var get: Verifiable<ReturnType> {
      verifiableBuilder.verifiable(function: property, file: file, line: line)
    }

    public func set(_ predicate: Predicate<ReturnType>) -> Verifiable<Void> {
      verifiableBuilder.verifiable(predicate, function: property, file: file, line: line)
    }

    public func set(_ value: ReturnType) -> Verifiable<Void> {
      verifiableBuilder.verifiable(value, function: property, file: file, line: line)
    }
  }
}
