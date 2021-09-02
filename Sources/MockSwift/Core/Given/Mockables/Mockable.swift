// Mockable.swift
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

/// Represents a function call that returns `ReturnType` and can be stubbed.
public class Mockable<ReturnType> {
  // MARK: - Properties

  private let behaviourRegister: BehaviourRegister
  private let functionIdentifier: FunctionIdentifier
  private let parametersPredicates: [AnyPredicate]

  // MARK: - Init

  init(_ behaviourRegister: BehaviourRegister,
       _ functionIdentifier: FunctionIdentifier,
       _ parametersPredicates: [AnyPredicate]) {
    self.behaviourRegister = behaviourRegister
    self.functionIdentifier = functionIdentifier
    self.parametersPredicates = parametersPredicates
  }

  // MARK: - Public Methods

  /// Registers a return value.
  /// - Parameter value: Value to register.
    public func willReturn(file: StaticString = #file, line: UInt = #line, _ value: ReturnType) {
        let behaviour = FunctionBehaviour(source: (file, line)) { _ in value }
    behaviourRegister.record(BehaviourTrigger(predicates: parametersPredicates,
                                              behaviour: behaviour),
                             for: functionIdentifier)
  }

  /// Registers return values.
  /// - Parameter values: Values to register.
  public func willReturn(file: StaticString = #file, line: UInt = #line, _ values: ReturnType...) {
    var returns = values
    let behaviour = FunctionBehaviour(source: (file, line)) { _ in
      returns.count == 1 ? returns[0] : returns.removeFirst()
    }
    behaviourRegister.record(BehaviourTrigger(predicates: parametersPredicates,
                                              behaviour: behaviour),
                             for: functionIdentifier)
  }

  /// Used to disambiguate the `ReturnType`.
  /// - Parameter type: The type to disambiguate.
  /// - Returns: `self` with `ReturnType` disambiguated.
  public func disambiguate(with type: ReturnType.Type) -> Self { self }

  /// Registers a block to excecute.
  /// - Parameter completion: Block to be excecuted.
  public func will(file: StaticString = #file,
                   line: UInt = #line,
                   _ completion: @escaping ([Any]) throws -> ReturnType) {
    let behaviour = FunctionBehaviour(source: (file, line), handler: completion)
    behaviourRegister.record(BehaviourTrigger(predicates: parametersPredicates,
                                              behaviour: behaviour),
                             for: functionIdentifier)
  }

  /// Registers an error.
  /// - Parameter error: Error to register.
  public func willThrow(file: StaticString = #file, line: UInt = #line, _ error: Error) {
    let behaviour = FunctionBehaviour(source: (file, line)) { _ in throw error }
    behaviourRegister.record(BehaviourTrigger(predicates: parametersPredicates,
                                              behaviour: behaviour),
                             for: functionIdentifier)
  }

  /// Registers errors.
  /// - Parameter errors: Errors to register.
  public func willThrow(file: StaticString = #file, line: UInt = #line, _ errors: Error...) {
    var throwables = errors
    let behaviour = FunctionBehaviour(source: (file, line)) { _ in
      throw throwables.count == 1 ? throwables[0] : throwables.removeFirst()
    }
    behaviourRegister.record(BehaviourTrigger(predicates: parametersPredicates,
                                              behaviour: behaviour),
                             for: functionIdentifier)
  }
}

public extension Mockable where ReturnType == Void {
  /// Registers an empty block to excecute.
  /// - SeeAlso: `will(_ completion:)`
  func willDoNothing() {
    will { _ in }
  }
}
