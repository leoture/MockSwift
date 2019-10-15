//ErrorHandler.swift
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

class ErrorHandler {
  func handle<Type>(_ value: InternalError, file: StaticString = #file, line: UInt = #line) -> Type {
    fatalError(value.description, file: file, line: line)
  }
}

enum InternalError {
  case cast(source: Any, target: Any)
  case castTwice(source: Any, firstTarget: Any, secondTarget: Any)
  case noDefinedBehaviour(for: FunctionIdentifier, with: [ParameterType])
  case tooManyDefinedBehaviour(for: FunctionIdentifier, with: [ParameterType])
}

extension InternalError: CustomStringConvertible {

  var description: String {
    switch self {
    case let .cast(source: source, target: target):
      return "\(source) can not be cast to \(target)."
    case let .castTwice(source: source, firstTarget: firstTarget, secondTarget: secondTarget):
      return "\(source) can not be cast to \(firstTarget) or to \(secondTarget)."
    case let .noDefinedBehaviour(for: function, with: parameters):
      return "Attempt to call \(function.callDescription(with: parameters)) but there is no defined behaviour for this call."
    case let .tooManyDefinedBehaviour(for: function, with: parameters):
      return "Attempt to call \(function.callDescription(with: parameters)) but there too many defined behaviour."
    }
  }
}

extension InternalError: Equatable {
  static func == (lhs: InternalError, rhs: InternalError) -> Bool {
    switch (lhs, rhs) {
    case (.cast, .cast),
         (.castTwice, .castTwice),
         (.noDefinedBehaviour, noDefinedBehaviour),
         (.tooManyDefinedBehaviour, .tooManyDefinedBehaviour):
      return lhs.description == rhs.description
    default: return false
    }
  }

}
