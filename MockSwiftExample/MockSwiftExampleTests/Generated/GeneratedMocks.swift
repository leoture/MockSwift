// Generated using Sourcery 0.17.0 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT


import Foundation
import MockSwift
@testable import MockSwiftExample










// MARK: - Basic
extension Mock: Basic where WrappedType == Basic {

  public func doSomething() {
    mocked()
  }
  public func doSomething() -> Int {
    mocked()
  }
  public func doSomething() -> String {
    mocked()
  }
  public func doSomething(arg: String) -> String {
    mocked(arg)
  }
  public func doSomething(arg1: String, arg2: Int) -> String {
    mocked(arg1, arg2)
  }
  public func doSomething(with arg: String) -> String {
    mocked(arg)
  }
  public func doSomething(with arg1: String, and arg2: Bool) -> String {
    mocked(arg1, arg2)
  }
}


extension MockGiven where WrappedType == Basic {

  public func doSomething() -> Mockable<Void> {
    mockable()
  }

  public func doSomething() -> Mockable<Int> {
    mockable()
  }

  public func doSomething() -> Mockable<String> {
    mockable()
  }

  public func doSomething(arg: Predicate<String>) -> Mockable<String> {
    mockable(arg)
  }

  public func doSomething(arg1: Predicate<String>, arg2: Predicate<Int>) -> Mockable<String> {
    mockable(arg1, arg2)
  }

  public func doSomething(with arg: Predicate<String>) -> Mockable<String> {
    mockable(arg)
  }

  public func doSomething(with arg1: Predicate<String>, and arg2: Predicate<Bool>) -> Mockable<String> {
    mockable(arg1, arg2)
  }
}


extension MockThen where WrappedType == Basic {

  public func doSomething() -> Verifiable<Void> {
    verifiable()
  }

  public func doSomething() -> Verifiable<Int> {
    verifiable()
  }

  public func doSomething() -> Verifiable<String> {
    verifiable()
  }

  public func doSomething(arg: Predicate<String>) -> Verifiable<String> {
    verifiable(arg)
  }

  public func doSomething(arg1: Predicate<String>, arg2: Predicate<Int>) -> Verifiable<String> {
    verifiable(arg1, arg2)
  }

  public func doSomething(with arg: Predicate<String>) -> Verifiable<String> {
    verifiable(arg)
  }

  public func doSomething(with arg1: Predicate<String>, and arg2: Predicate<Bool>) -> Verifiable<String> {
    verifiable(arg1, arg2)
  }
}

