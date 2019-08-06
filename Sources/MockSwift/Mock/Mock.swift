//Mock.swift
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

@propertyWrapper
public class Mock<WrappedType> {
  
  private let callRegister: CallRegister
  private let behaviourRegister: BehaviourRegister

  init(callRegister: CallRegister, behaviourRegister: BehaviourRegister) {
    self.callRegister = callRegister
    self.behaviourRegister = behaviourRegister
  }

  public var wrappedValue: WrappedType {
    self as! WrappedType
  }

  public func mocked(_ parameters: Any... , function: String = #function) {
    let identifier = FunctionIdentifier(function: function, return: Void.self)
    willCall(function: identifier, with: parameters)
    return call(function: identifier, with: parameters)
  }
  
  public func mocked<ReturnType>(_ parameters: Any... , function: String = #function) -> ReturnType {
    let identifier = FunctionIdentifier(function: function, return: ReturnType.self)
    willCall(function: identifier, with: parameters)
    return call(function: identifier, with: parameters)
  }

  private func willCall(function: FunctionIdentifier, with parameters: [Any]) {
    callRegister.recordCall(for: function, with: parameters)
  }

  private func call<ReturnType>(function: FunctionIdentifier, with parameters: [Any]) -> ReturnType {
    let behaviours = behaviourRegister.recordedBehaviours(for: function, concernedBy: parameters)

    switch behaviours.count {
    case 1: return behaviours[0].onReceive(parameters) as! ReturnType
    //TODO: handle error
    case 0: fatalError()
    //TODO: handle error
    default: fatalError()
    }
  }
}
