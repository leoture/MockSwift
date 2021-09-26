// FunctionBehaviourRegister.swift
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

class FunctionBehaviourRegister: BehaviourRegister {
    private var functionBehaviours: [FunctionIdentifier: [BehaviourTrigger]]
    private var unusedBehaviours: [UUID]

    var unusedFunctionBehaviours: [FunctionIdentifier: [BehaviourTrigger]] {
        functionBehaviours.filter { element in
            element.value.contains { value in
                unusedBehaviours.contains(value.behaviour.identifier)
            }
        }
    }

    init() {
        functionBehaviours = [:]
        unusedBehaviours = []
    }

    func recordedBehaviours(for identifier: FunctionIdentifier,
                            concernedBy parameters: [ParameterType]) -> [FunctionBehaviour] {
        functionBehaviours[identifier, default: []]
            .filter { $0.predicates.satisfy(by: parameters) }
            .map { $0.behaviour }
    }

    func record(_ trigger: BehaviourTrigger,
                for identifier: FunctionIdentifier) {
        functionBehaviours[identifier, default: []].append(trigger)
        unusedBehaviours.append(trigger.behaviour.identifier)
    }

    func makeBehaviourUsed(for identifier: UUID) {
        unusedBehaviours.removeAll { $0 == identifier }
    }
}
