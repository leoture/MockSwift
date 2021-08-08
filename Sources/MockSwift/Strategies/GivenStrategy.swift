// GivenStrategy.swift
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

class GivenStrategy: StrategyDecorate {
    let behaviourRegister: BehaviourRegister
    let errorHandler: ErrorHandler

    init(next stategy: Strategy,
         behaviourRegister: BehaviourRegister,
         errorHandler: ErrorHandler) {
        self.behaviourRegister = behaviourRegister
        self.errorHandler = errorHandler
        super.init(stategy)
    }

    override func resolve<ReturnType>(for identifier: FunctionIdentifier,
                                      concernedBy parameters: [ParameterType]) -> ReturnType {
        let behaviours = behaviourRegister.recordedBehaviours(for: identifier, concernedBy: parameters)

        guard behaviours.count < 2 else {
            return errorHandler.handle(.tooManyDefinedBehaviour(for: identifier, with: parameters))
        }

        guard let behaviour = behaviours.first,
              let result: ReturnType = behaviour.handle(with: parameters) else {
                  return super.resolve(for: identifier, concernedBy: parameters)
              }

        behaviourRegister.makeBehaviourUsed(for: behaviour.identifier)
        return result
    }

    override func resolveThrowable<ReturnType>(for identifier: FunctionIdentifier,
                                               concernedBy parameters: [ParameterType]) throws -> ReturnType {
        let behaviours = behaviourRegister.recordedBehaviours(for: identifier, concernedBy: parameters)

        guard behaviours.count < 2 else {
            return errorHandler.handle(.tooManyDefinedBehaviour(for: identifier, with: parameters))
        }

        guard let behaviour = behaviours.first else {
            return try super.resolveThrowable(for: identifier, concernedBy: parameters)
        }

        do {
            if let result: ReturnType = try behaviour.handleThrowable(with: parameters) {
                behaviourRegister.makeBehaviourUsed(for: behaviour.identifier)
                return result
            }
        } catch {
            behaviourRegister.makeBehaviourUsed(for: behaviour.identifier)
            throw error
        }

        return try super.resolveThrowable(for: identifier, concernedBy: parameters)
    }
}
