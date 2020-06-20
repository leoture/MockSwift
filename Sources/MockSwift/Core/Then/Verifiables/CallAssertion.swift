//CallAssertion.swift
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

//TODO: to test
public class Assertion {
  let times: Predicate<Int>
  let functionIdentifier: FunctionIdentifier
  let parametersPredicates: [AnyPredicate]
  let calls: [FunctionCall]
  let file: StaticString
  let line: UInt

  init(times: Predicate<Int>,
       functionIdentifier: FunctionIdentifier,
       parametersPredicates: [AnyPredicate],
       file: StaticString,
       line: UInt,
       calls: [FunctionCall] ) {
    self.times = times
    self.functionIdentifier = functionIdentifier
    self.parametersPredicates = parametersPredicates
    self.file = file
    self.line = line
    self.calls = calls
  }

  func reduced() -> Assertion {
    guard !calls.isEmpty else {
      return self
    }
    var sortedCalls = self.calls.sorted { (lhs, rhs) -> Bool in
      lhs.time < rhs.time
    }

    var minimumCalls: [FunctionCall] = []
    while !times.satisfy(by: minimumCalls.count) {
      minimumCalls.append(sortedCalls.removeFirst())
    }
    return Assertion(times: times,
                     functionIdentifier: functionIdentifier,
                     parametersPredicates: parametersPredicates,
                     file: file,
                     line: line,
                     calls: minimumCalls)
  }
}
