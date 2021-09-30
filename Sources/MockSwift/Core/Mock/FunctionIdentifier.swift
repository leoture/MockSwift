// FunctionIdentifier.swift
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

struct FunctionIdentifier: Equatable, Hashable {
    enum Kind {
        case function
        case property
        case `subscript`

        var normalizer: Normalizer {
            switch self {
            case .function:
                return FunctionNormalizer()
            case .property:
                return PropertyNormalizer()
            case .subscript:
                return SubscriptNormalizer()
            }
        }
    }

    // MARK: - Properties

    private let identifier: String!
    private let kind: Kind

    // MARK: - Initializers

    init<ReturnType>(function: String, return: ReturnType.Type) {
        if function.starts(with: "subscript") {
            kind = .subscript
        } else if function.contains("(") {
            kind = .function
        } else {
            kind = .property
        }

        self.identifier = kind.normalizer.normalize(function: function, returning: "\(ReturnType.self)".voidEscaped)
    }

    // MARK: - Methods

    func callDescription(with parameters: [ParameterType]) -> String {
        kind.normalizer.callDescription(of: identifier, with: parameters)
    }
}

// MARK: - Privates

protocol Normalizer {
    func normalize(function: String, returning: String) -> String
    func callDescription(of function: String, with parameters: [ParameterType]) -> String
}

private struct FunctionNormalizer: Normalizer {
    func normalize(function: String, returning: String) -> String {
        "\(function) -> \(returning)"
    }

    func callDescription(of function: String, with parameters: [ParameterType]) -> String {
        var callDescription = ""
        var currentParameterIndex = 0
        let separator = ", "
        var needSeparator = false

        for character in function {
            if needSeparator, character != ")" {
                callDescription.append(separator)
            }
            needSeparator = false

            callDescription.append(character)

            if character == ":" {
                callDescription.append(" \(parameters[currentParameterIndex] ?? "nil")")
                currentParameterIndex += 1
                needSeparator = true
            }
        }

        return callDescription
    }
}

private struct PropertyNormalizer: Normalizer {
    func normalize(function: String, returning: String) -> String {
        "\(function): \(returning)"
    }

    func callDescription(of function: String, with parameters: [ParameterType]) -> String {
        if parameters.isEmpty {
            return function
        }

        guard let index = function.firstIndex(of: ":") else { return "" }
        return function.replacingCharacters(in: index..<function.endIndex,
                                            with: " = \(parameters[0] ?? "nil")")
    }

}

private struct SubscriptNormalizer: Normalizer {
    func normalize(function: String, returning: String) -> String {
        "\(function) -> \(returning)"
    }

    func callDescription(of function: String, with parameters: [ParameterType]) -> String {
        let writing = function.filter { $0 == ":" }.count < parameters.count

        var callDescription: String = ""
        var currentParameterIndex = 0
        let separator = ", "
        var needSeparator = false

        for character in function {
            if writing && character == "-" {
                break
            }
            if needSeparator, character != ")" {
                callDescription.append(separator)
            }
            needSeparator = false

            callDescription.append(character)

            if character == ":" {
                callDescription.append(" \(parameters[currentParameterIndex] ?? "nil")")
                currentParameterIndex += 1
                needSeparator = true
            }
        }
        if writing {
            callDescription.append("= \(parameters[currentParameterIndex] ?? "nil")")
        }
        return callDescription
    }
}

private extension String {
    var voidEscaped: String {
        self == "()" ? "Void" : self
    }
}
