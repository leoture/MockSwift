// BehaviourRegisterMock.swift
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

class BehaviourRegisterMock: BehaviourRegister {
    var unusedFunctionBehavioursReturn: [FunctionIdentifier: [BehaviourTrigger]]!
    var unusedFunctionBehavioursCount = 0
    var unusedFunctionBehaviours: [FunctionIdentifier: [BehaviourTrigger]] {
        unusedFunctionBehavioursCount += 1
        return unusedFunctionBehavioursReturn
    }

    var recordedBehavioursReturn: [FunctionBehaviour]!
    var recordedBehavioursReceived: [(identifier: FunctionIdentifier, parameters: [ParameterType])] = []

    func recordedBehaviours(for identifier: FunctionIdentifier,
                            concernedBy parameters: [ParameterType]) -> [FunctionBehaviour] {
        recordedBehavioursReceived.append((identifier, parameters))
        return recordedBehavioursReturn
    }

    var recordReceived: [(trigger: BehaviourTrigger, identifier: FunctionIdentifier)] = []

    func record(_ trigger: BehaviourTrigger,
                for identifier: FunctionIdentifier) {
        recordReceived.append((trigger, identifier))
    }

    var makeBehaviourUsedReceived: [UUID] = []
    var makeBehaviourUsedCalled: Bool {
        makeBehaviourUsedReceived.count > 0
    }
    func makeBehaviourUsed(for identifier: UUID) {
        makeBehaviourUsedReceived.append(identifier)
    }
}
