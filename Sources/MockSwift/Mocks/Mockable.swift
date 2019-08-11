//Mockable.swift
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

public class Mockable<ReturnType> {
  private let behaviourRegister: BehaviourRegister
  private let functionIdentifier: FunctionIdentifier
  private let parametersPredicates: [AnyPredicate]

  init(_ behaviourRegister: BehaviourRegister,
       _ functionIdentifier: FunctionIdentifier,
       _ parametersPredicates: [AnyPredicate]) {
    self.behaviourRegister = behaviourRegister
    self.functionIdentifier = functionIdentifier
    self.parametersPredicates = parametersPredicates
  }

  public func willReturn(_ value: ReturnType) {
    let behaviour = FunctionBehaviour { _ in value }
    behaviourRegister.record(behaviour, for: functionIdentifier, when: parametersPredicates)
  }

  public  func disambiguate(with type: ReturnType.Type) -> Self { self }

  public func will(_ completion: @escaping ([Any]) -> ReturnType) {
    let behaviour = FunctionBehaviour(handler: completion)
    behaviourRegister.record(behaviour, for: functionIdentifier, when: parametersPredicates)
  }
}
