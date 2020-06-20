// CallAssertion.swift
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

class CallAssertion {
  // MARK: - Properties

  let times: Predicate<Int>
  let functionIdentifier: FunctionIdentifier
  let parametersPredicates: [AnyPredicate]
  let calls: [FunctionCall]
  let previous: Assertion?

  // MARK: - Initializers

  init(times: Predicate<Int>,
       functionIdentifier: FunctionIdentifier,
       parametersPredicates: [AnyPredicate],
       calls: [FunctionCall],
       previous: Assertion? = nil) {
    self.times = times
    self.functionIdentifier = functionIdentifier
    self.parametersPredicates = parametersPredicates
    self.calls = calls
    self.previous = previous
  }

  // MARK: - Private methods

  private func minimumCalls() -> [FunctionCall] {
    var sortedCalls = calls.sorted { (lhs, rhs) -> Bool in
      lhs.time < rhs.time
    }

    var result: [FunctionCall] = []

    while !times.satisfy(by: result.count) {
      result.append(sortedCalls.removeFirst())
    }
    return result
  }
}

// MARK: - Assertion

extension CallAssertion: Assertion {
  var isValid: Bool {
    times.satisfy(by: calls.count)
  }

  var firstValidTime: TimeInterval {
    minimumCalls().map(\.time).max() ?? previous?.firstValidTime ?? 0
  }

  var description: String {
    let callDescription = functionIdentifier.callDescription(with: parametersPredicates)
    let formatedTimes = times.description.replacingOccurrences(of: "greater", with: "more")

    var previousDescription = ""
    if let previous = self.previous {
      previousDescription = " after \(previous)"
    }

    if isValid {
      return "\(callDescription) has been called \(formatedTimes) time(s)\(previousDescription)."
    } else {
      return "\(callDescription)" +
      " is expected to be called \(formatedTimes) time(s) but is called \(calls.count) time(s)\(previousDescription)."
    }
  }
}
