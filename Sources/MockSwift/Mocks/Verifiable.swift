//Verifiable.swift
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

public class Verifiable<ReturnType> {
  private let callRegister: CallRegister
  private let functionIdentifier: FunctionIdentifier
  private let parametersPredicates: [AnyPredicate]
  private let failureRecorder: FailureRecorder

  init(callRegister: CallRegister,
       functionIdentifier: FunctionIdentifier,
       parametersPredicates: [AnyPredicate],
       failureRecorder: FailureRecorder) {
    self.callRegister = callRegister
    self.functionIdentifier = functionIdentifier
    self.parametersPredicates = parametersPredicates
    self.failureRecorder = failureRecorder
  }

  public  func disambiguate(with type: ReturnType.Type) -> Self { self }

  public  func called(times: Predicate<Int> = >0, file: StaticString = #file, line: UInt = #line) {
    let count = callRegister.recordedCall(for: functionIdentifier, when: parametersPredicates).count
    if !times.satisfy(by: count) {
      failureRecorder.recordFailure(message: callFailureMessage(expectedCalls: times, actualCalls: count),
                             file: file,
                             line: line)
    }
  }

  public  func called(times: Int, file: StaticString = #file, line: UInt = #line) {
    called(times: ==times, file: file, line: line)
  }

  private func callFailureMessage(expectedCalls: Predicate<Int>, actualCalls: Int) -> String {
    let callDescription = functionIdentifier.callDescription(with: parametersPredicates)
    return "\(callDescription) expect to be called \(expectedCalls) time(s) but is call \(actualCalls) time(s)"
  }
}
