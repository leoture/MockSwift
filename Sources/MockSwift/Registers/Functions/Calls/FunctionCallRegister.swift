// FunctionCallRegister.swift
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

class FunctionCallRegister: CallRegister {
  private var calls: [FunctionIdentifier: [FunctionCall]]
  private var unverifiedCalls: [UUID]

  var allCallHaveBeenVerified: Bool {
    unverifiedCalls.isEmpty
  }

  init() {
    calls = [:]
    unverifiedCalls = []
  }

  func recordCall(for identifier: FunctionIdentifier, with parameters: [ParameterType]) {
    let callIdentifier = UUID()
    calls[identifier, default: []].append(FunctionCall(identifier: callIdentifier, parameters: parameters))
    unverifiedCalls.append(callIdentifier)
  }

  func recordedCall(for identifier: FunctionIdentifier, when matchs: [AnyPredicate]) -> [FunctionCall] {
    calls[identifier]?.filter { functionCall in
      matchs.satisfy(by: functionCall.parameters)
    } ?? []
  }

  func makeCallVerified(for identifier: UUID) {
    unverifiedCalls.removeAll { $0 == identifier }
    }
}
