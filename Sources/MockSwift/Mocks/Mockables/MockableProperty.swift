//MockableProperty.swift
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

public class MockableProperty {
  private let mockableBuilder: MockableBuilder
  private let property: String
  private let file: StaticString
  private let line: UInt

  init(property: String, file: StaticString, line: UInt, mockableBuilder: MockableBuilder) {
    self.property = property
    self.file = file
    self.line = line
    self.mockableBuilder = mockableBuilder
  }
}

extension MockableProperty {
  public class Readable<ReturnType>: MockableProperty {
    public var get: Mockable<ReturnType> {
      mockableBuilder.mockable(function: property, file: file, line: line)
    }
  }

  public class Writable<ReturnType>: MockableProperty {
    public var get: Mockable<ReturnType> {
      mockableBuilder.mockable(function: property, file: file, line: line)
    }

    public func set(_ predicate: Predicate<ReturnType>) -> Mockable<Void> {
      mockableBuilder.mockable(predicate, function: property, file: file, line: line)
    }

    public func set(_ value: ReturnType) -> Mockable<Void> {
      mockableBuilder.mockable(value, function: property, file: file, line: line)
    }
  }
}
