import XCTest
import MockSwift

struct User: Equatable {
  let identifier: String
  let name: String
}

protocol UserService {
  func fetch(identifier: String) -> User
  func fetch(identifier: String) -> String
}

extension Mock: UserService where WrappedType == UserService {
  func fetch(identifier: String) -> User { mocked(identifier) }
  func fetch(identifier: String) -> String { mocked(identifier) }
}

extension MockGiven where WrappedType == UserService {
  func fetch(identifier: Predicate<String>) -> Mockable<User> { mockable(identifier) }
  func fetch(identifier: Predicate<String>) -> Mockable<String> { mockable(identifier) }
}

extension MockThen where WrappedType == UserService {
  func fetch(identifier: Predicate<String>) -> Verifiable<User> { verifiable(identifier) }
  func fetch(identifier: Predicate<String>) -> Verifiable<String> { verifiable(identifier) }
}

extension User: GlobalStub {
  static func stub() -> User {
    User(identifier: "id", name: "John")
  }
}

class MyTests: XCTestCase {
  @Mock private var service: UserService

  func test_fetch() {
    // Given
    let expectedUser = User(identifier: "id", name: "John")

    given(service)
      .fetch(identifier: .any())
      .willReturn(expectedUser)

    // When
    let user: User = service.fetch(identifier: "id")

    // Then
    then(service)
      .fetch(identifier: .any())
      .disambiguate(with: User.self)
      .called()
    XCTAssertEqual(user, expectedUser)
  }

  func test_fetch_withDefault() {
    // Given
    let expectedUser = User(identifier: "id", name: "John")

    // When
    let user: User = service.fetch(identifier: "id")

    // Then
    XCTAssertEqual(user, expectedUser)
  }
}

MyTests.defaultTestSuite.run()

let myPredicate = Predicate<User>.match(description: "User.identifer == id") { user in
  user.identifier == "id"
}

myPredicate.satisfy(by: User(identifier: "id", name: "John"))
myPredicate.satisfy(by: User(identifier: "identifier", name: "John"))

extension User: AnyPredicate {
  var description: String {
    "User.identifer == \(identifier)"
  }

  func satisfy(by element: Any) -> Bool {
    guard let element = element as? User  else {
      return false
    }
    return identifier == element.identifier
  }
}

User(identifier: "id", name: "").satisfy(by: User(identifier: "id", name: "John"))
User(identifier: "id", name: "").satisfy(by: User(identifier: "identifier", name: "John"))
