struct User {
  let name: String
}

protocol Service {
  func function(identifier: String) -> User
}

import XCTest
import MockSwift

extension Mock: Service where WrappedType == Service {
  func function(identifier: String) -> User { mocked(identifier) }
}

extension MockGiven where WrappedType == Service {
  func function(identifier: Predicate<String>) -> Mockable<User> { mockable(identifier) }
}

extension MockThen where WrappedType == Service {
  func function(identifier: Predicate<String>) -> Verifiable<User> { verifiable(identifier) }
}

extension Predicate {
  static func not(_ keyPath: KeyPath<Input, Bool>) -> Predicate<Input> {
    .match { !$0[keyPath: keyPath]}
  }
}

class MyTests: XCTestCase {
  @Mock private var service: Service

  func test() {
    // Given
    let expectedUser = User(name: "John")

    given(_service)
      .function(identifier: .not(\.isEmpty))
      .willReturn(expectedUser)

    // When
    let john = service.function(identifier: "id")

    // Then
    then(_service)
      .function(identifier: .any)
      .called()
  }
}

MyTests.defaultTestSuite.run()
