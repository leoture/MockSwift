//FunctionIdentifier.swift
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

struct FunctionIdentifier: Equatable, Hashable {

  // MARK: - Properties

  private let identifier: String!

  // MARK: - Initializers

  init<ReturnType>(function: String, return: ReturnType.Type) {
    var normalizedFunction = function

    if let normalized = normalizedAsProperty(function: function, return: ReturnType.self) {
      normalizedFunction = normalized
    }

    if let normalized = normalizedAsSubscript(function: function, return: ReturnType.self) {
      normalizedFunction = normalized
    }

    self.identifier = "\(normalizedFunction) -> \(ReturnType.self)"
  }

  // MARK: - Methods

  func callDescription(with parameters: [ParameterType]) -> String {
    var callDescription: String = ""
    var currentIndex = 0
    let separator = ", "
    var needSeparator = false

    for character in identifier {
      if needSeparator && character != ")" {
        callDescription.append(separator)
      }
      needSeparator = false

      callDescription.append(character)

      if character == ":" {
        callDescription.append(" \(parameters[currentIndex] ?? "nil" )")
        currentIndex += 1
        needSeparator = true
      }
    }

    return callDescription
  }

}

// MARK: - Private methods

private func normalizedAsProperty<ReturnType>(function: String, return: ReturnType.Type) -> String? {
  guard !function.contains("(") else {
    return nil
  }
  return ReturnType.self == Void.self ? function+"(newValue:)" : function+"()"
}

private func normalizedAsSubscript<ReturnType>(function: String, return: ReturnType.Type) -> String? {
  guard function.starts(with: "subscript(") else {
    return nil
  }
  return ReturnType.self == Void.self ? function + "(newValue:)" : function
}
