// CallRegisterMock.swift
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
@testable import MockSwift

class CallRegisterMock: CallRegister {
  var recordCallReceived: [(identifier: FunctionIdentifier, parameters: [ParameterType])] = []
  func recordCall(for identifier: FunctionIdentifier, with parameters: [ParameterType]) {
    recordCallReceived.append((identifier, parameters))
  }

  var recordedCallReceived: [(identifier: FunctionIdentifier, matchs: [AnyPredicate])] = []
  var recordedCallReturn: [FunctionCall]!
  func recordedCall(for identifier: FunctionIdentifier, when matchs: [AnyPredicate]) -> [FunctionCall] {
    recordedCallReceived.append((identifier, matchs))
    return recordedCallReturn
  }
}
