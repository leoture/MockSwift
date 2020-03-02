// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import MockSwift
@testable import MockSwiftExample

















// MARK: - BasicMethod
extension Mock: BasicMethod where WrappedType == BasicMethod {
  public func doSomething() {
    mocked()
  }
  public func doSomething() -> Int {
    mocked()
  }
  public func doSomething() -> String? {
    mocked()
  }
  public func doSomething(arg: String) throws -> String {
    try mockedThrowable(arg)
  }
  public func doSomething(arg1: String, arg2: Int?) -> String {
    mocked(arg1, arg2)
  }
  public func doSomething(with arg: String) -> String {
    mocked(arg)
  }
  public func doSomething(with arg1: String, and arg2: Bool) -> String {
    mocked(arg1, arg2)
  }
}

extension Given where WrappedType == BasicMethod {
  public func doSomething() -> Mockable<Void> {
    mockable()
  }
  public func doSomething() -> Mockable<Int> {
    mockable()
  }
  public func doSomething() -> Mockable<String?> {
    mockable()
  }
  public func doSomething(arg: Predicate<String>) -> Mockable<String> {
    mockable(arg)
  }
  public func doSomething(arg: String) -> Mockable<String> {
    mockable(arg)
  }
  public func doSomething(arg1: Predicate<String>, arg2: Predicate<Int?>) -> Mockable<String> {
    mockable(arg1, arg2)
  }
  public func doSomething(arg1: String, arg2: Int?) -> Mockable<String> {
    mockable(arg1, arg2)
  }
  public func doSomething(with arg: Predicate<String>) -> Mockable<String> {
    mockable(arg)
  }
  public func doSomething(with arg: String) -> Mockable<String> {
    mockable(arg)
  }
  public func doSomething(with arg1: Predicate<String>, and arg2: Predicate<Bool>) -> Mockable<String> {
    mockable(arg1, arg2)
  }
  public func doSomething(with arg1: String, and arg2: Bool) -> Mockable<String> {
    mockable(arg1, arg2)
  }
}

extension Then where WrappedType == BasicMethod {
  public func doSomething() -> Verifiable<Void> {
    verifiable()
  }
  public func doSomething() -> Verifiable<Int> {
    verifiable()
  }
  public func doSomething() -> Verifiable<String?> {
    verifiable()
  }
  public func doSomething(arg: Predicate<String>) -> Verifiable<String> {
    verifiable(arg)
  }
  public func doSomething(arg: String) -> Verifiable<String> {
    verifiable(arg)
  }
  public func doSomething(arg1: Predicate<String>, arg2: Predicate<Int?>) -> Verifiable<String> {
    verifiable(arg1, arg2)
  }
  public func doSomething(arg1: String, arg2: Int?) -> Verifiable<String> {
    verifiable(arg1, arg2)
  }
  public func doSomething(with arg: Predicate<String>) -> Verifiable<String> {
    verifiable(arg)
  }
  public func doSomething(with arg: String) -> Verifiable<String> {
    verifiable(arg)
  }
  public func doSomething(with arg1: Predicate<String>, and arg2: Predicate<Bool>) -> Verifiable<String> {
    verifiable(arg1, arg2)
  }
  public func doSomething(with arg1: String, and arg2: Bool) -> Verifiable<String> {
    verifiable(arg1, arg2)
  }
}

// MARK: - BasicSubscript
extension Mock: BasicSubscript where WrappedType == BasicSubscript {
  public subscript(arg1: String, arg2: Int) -> Bool {
    get {
      mocked(arg1, arg2)
    }
    set {
      mocked(arg1, arg2, newValue)
    }
  }
  public subscript(with arg1: String, and arg2: Int) -> String {
    get {
      mocked(arg1, arg2)
    }
  }
}

extension Given where WrappedType == BasicSubscript {
  public subscript(arg1: Predicate<String>, arg2: Predicate<Int>) -> MockableSubscript.Writable<Bool> {
    mockable(arg1, arg2)
  }
  public subscript(arg1: String, arg2: Int) -> MockableSubscript.Writable<Bool> {
   mockable(arg1, arg2)
  }
  public subscript(with arg1: Predicate<String>, and arg2: Predicate<Int>) -> MockableSubscript.Readable<String> {
    mockable(arg1, arg2)
  }
  public subscript(with arg1: String, and arg2: Int) -> MockableSubscript.Readable<String> {
   mockable(arg1, arg2)
  }
}

extension Then where WrappedType == BasicSubscript {
  public subscript(arg1: Predicate<String>, arg2: Predicate<Int>) -> VerifiableSubscript.Writable<Bool> {
    verifiable(arg1, arg2)
  }
  public subscript(arg1: String, arg2: Int) -> VerifiableSubscript.Writable<Bool> {
   verifiable(arg1, arg2)
  }
  public subscript(with arg1: Predicate<String>, and arg2: Predicate<Int>) -> VerifiableSubscript.Readable<String> {
    verifiable(arg1, arg2)
  }
  public subscript(with arg1: String, and arg2: Int) -> VerifiableSubscript.Readable<String> {
   verifiable(arg1, arg2)
  }
}

// MARK: - EscapingMethod
extension Mock: EscapingMethod where WrappedType == EscapingMethod {
  public func call(_ block: @escaping (String) -> Bool) -> Bool {
    mocked(block)
  }
}

extension Given where WrappedType == EscapingMethod {
  public func call(_ block: Predicate<(String) -> Bool>) -> Mockable<Bool> {
    mockable(block)
  }
  public func call(_ block: @escaping (String) -> Bool) -> Mockable<Bool> {
    mockable(block)
  }
}

extension Then where WrappedType == EscapingMethod {
  public func call(_ block: Predicate<(String) -> Bool>) -> Verifiable<Bool> {
    verifiable(block)
  }
  public func call(_ block: @escaping (String) -> Bool) -> Verifiable<Bool> {
    verifiable(block)
  }
}

// MARK: - EscapingSubscript
extension Mock: EscapingSubscript where WrappedType == EscapingSubscript {
  public subscript(block: @escaping (String) -> Bool) -> Bool {
    get {
      mocked(block)
    }
    set {
      mocked(block, newValue)
    }
  }
}

extension Given where WrappedType == EscapingSubscript {
  public subscript(block: Predicate<(String) -> Bool>) -> MockableSubscript.Writable<Bool> {
    mockable(block)
  }
  public subscript(block: @escaping (String) -> Bool) -> MockableSubscript.Writable<Bool> {
   mockable(block)
  }
}

extension Then where WrappedType == EscapingSubscript {
  public subscript(block: Predicate<(String) -> Bool>) -> VerifiableSubscript.Writable<Bool> {
    verifiable(block)
  }
  public subscript(block: @escaping (String) -> Bool) -> VerifiableSubscript.Writable<Bool> {
   verifiable(block)
  }
}

// MARK: - GenericMethod
extension Mock: GenericMethod where WrappedType == GenericMethod {
  public func doSomething<T>() -> T {
    mocked()
  }
  public func doSomething<T: Sequence>(with arg: T) {
    mocked(arg)
  }
  public func doSomething<T>(arg: T) throws -> T {
    try mockedThrowable(arg)
  }
  public func doSomething<T: Sequence, U>(arg1: T, arg2: U?) -> U where T.Element == U {
    mocked(arg1, arg2)
  }
  public func doSomething<T: Equatable, U: Equatable>(with arg1: T, and arg2: U) -> Bool {
    mocked(arg1, arg2)
  }
}

extension Given where WrappedType == GenericMethod {
  public func doSomething<T>() -> Mockable<T> {
    mockable()
  }
  public func doSomething<T: Sequence>(with arg: Predicate<T>) -> Mockable<Void> where T.Element == Int {
    mockable(arg)
  }
  public func doSomething<T: Sequence>(with arg: T) -> Mockable<Void> where T.Element == Int {
    mockable(arg)
  }
  public func doSomething<T>(arg: Predicate<T>) -> Mockable<T> {
    mockable(arg)
  }
  public func doSomething<T>(arg: T) -> Mockable<T> {
    mockable(arg)
  }
  public func doSomething<T: Sequence, U>(arg1: Predicate<T>, arg2: Predicate<U?>) -> Mockable<U> where T.Element == U {
    mockable(arg1, arg2)
  }
  public func doSomething<T: Sequence, U>(arg1: T, arg2: U?) -> Mockable<U> where T.Element == U {
    mockable(arg1, arg2)
  }
  public func doSomething<T: Equatable, U: Equatable>(with arg1: Predicate<T>, and arg2: Predicate<U>) -> Mockable<Bool> {
    mockable(arg1, arg2)
  }
  public func doSomething<T: Equatable, U: Equatable>(with arg1: T, and arg2: U) -> Mockable<Bool> {
    mockable(arg1, arg2)
  }
}

extension Then where WrappedType == GenericMethod {
  public func doSomething<T>() -> Verifiable<T> {
    verifiable()
  }
  public func doSomething<T: Sequence>(with arg: Predicate<T>) -> Verifiable<Void> where T.Element == Int {
    verifiable(arg)
  }
  public func doSomething<T: Sequence>(with arg: T) -> Verifiable<Void> where T.Element == Int {
    verifiable(arg)
  }
  public func doSomething<T>(arg: Predicate<T>) -> Verifiable<T> {
    verifiable(arg)
  }
  public func doSomething<T>(arg: T) -> Verifiable<T> {
    verifiable(arg)
  }
  public func doSomething<T: Sequence, U>(arg1: Predicate<T>, arg2: Predicate<U?>) -> Verifiable<U> where T.Element == U {
    verifiable(arg1, arg2)
  }
  public func doSomething<T: Sequence, U>(arg1: T, arg2: U?) -> Verifiable<U> where T.Element == U {
    verifiable(arg1, arg2)
  }
  public func doSomething<T: Equatable, U: Equatable>(with arg1: Predicate<T>, and arg2: Predicate<U>) -> Verifiable<Bool> {
    verifiable(arg1, arg2)
  }
  public func doSomething<T: Equatable, U: Equatable>(with arg1: T, and arg2: U) -> Verifiable<Bool> {
    verifiable(arg1, arg2)
  }
}

// MARK: - Properties
extension Mock: Properties where WrappedType == Properties {
  public var variable: String {
      get { mocked() }
      set { mocked(newValue) }
  }
  public var constant: Bool? {
    mocked()
  }
}

extension Given where WrappedType == Properties {
  public var variable: MockableProperty.Writable<String> {
    mockable()
  }
  public var constant: MockableProperty.Readable<Bool?> {
    mockable()
  }
}

extension Then where WrappedType == Properties {
  public var variable: VerifiableProperty.Writable<String> {
    verifiable()
  }
  public var constant: VerifiableProperty.Readable<Bool?> {
    verifiable()
  }
}

