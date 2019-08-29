# Welcome to ⭐️MockSwift⭐️ !
[![Build Status](https://travis-ci.com/leoture/MockSwift.svg?token=7mHp1J41yAdss7UzTesf&branch=master)](https://travis-ci.com/leoture/MockSwift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-brightgreen)](https://github.com/apple/swift-package-manager)
[![Swift](https://img.shields.io/badge/Swift-5.1-important)](https://swift.org)
[![license MIT](https://img.shields.io/badge/license-MIT-informational)](https://github.com/leoture/MockSwift/blob/master/LICENSE)  

MockSwift is a Mock library written in Swift for Swift.

###### Table of Contents
- [Usage](#usage)
- [Playgrounds](#playgrounds)
- [Installation](#installation)
- [Contribution](#contribution)
- [License](#license)

# Usage
>⚠️ Work in progress ⚠️  
> - Make `@Mock` available for `protocol` and `class` types.
> - Generate extensions for `Mock`, `MockGiven` and `MockThen`


If you need more details about the API, you can check out [our documentation](https://leoture.github.io/MockSwift/)  

Suppose that you have a `UserService` protocol.
```swift
struct User: Equatable {
  let identifier: String
  let name: String
}

protocol UserService {
  func fetch(identifier: String) -> User
}
```

#### General usage
Now, you can use `UserService` into your tests with the `@Mock` annotation.
```swift
class MyTests: XCTestCase {
  @Mock private var service: UserService

  func test_fetch() {
    // Given
    let expectedUser = User(identifier: "id", name: "John")

    given(_service)
      .fetch(identifier: .any)
      .willReturn(expectedUser)

    // When
    let user = service.fetch(identifier: "id")

    // Then
    then(_service)
      .fetch(identifier: .any)
      .called()
    XCTAssertEqual(user, expectedUser)
  }
}
```

#### Use Mock
To be able to use `Mock` as a `UserService`, you have to make it conform to the protocal like that:
```swift
extension Mock: UserService where WrappedType == UserService {
  func fetch(identifier: String) -> User { mocked(identifier) }
}
```
>⚠️ be careful to:
- call `mocked()` with all parameters in the same order.  

After that you can write `@Mock private var service: UserService` and `Mock<UserService>()`.

##### MockDefault
You can define a default value for any type.  
This value will be returned for any mocked method returning this type, only if no [behaviour](Use-MockGiven) has been defined.  
```swift
extension User: MockDefault {
  static func `default`() -> User {
    User(identifier: "id", name: "John")
  }
}
```

```swift
func test_fetch_withDefault() {
    // Given
    let expectedUser = User(identifier: "id", name: "John")

    // When
    let user = service.fetch(identifier: "id")

    // Then
    XCTAssertEqual(user, expectedUser)
}
```

### Use MockGiven
`MockGiven` allows you to define behaviour for a method.

```swift
extension MockGiven where WrappedType == UserService {
  func fetch(identifier: Predicate<String>) -> Mockable<User> { mockable(identifier) }
}
```
>⚠️ be careful to:
- call `mockable()` with all parameters in the same order.  
- the method name must be the same as the one in the `WrappedType`.
  - exemple: **fetch(identifer:)**
- the return type must be a `Mockable` with, as generic type, the same type as the return type of the method in the WrappedType.
  - exemple:
    - UserService.fetch(identifer:) -> User
    - MockGiven.fetch(identifer:) -> Mockable\<User>

To get it from a `Mock` use `given()` method.

##### Behaviour Rules
You can add as many behaviours as you like to a method. But make sure that, when you call the method, only one behaviour corresponds to it. Otherwise, the call will be cashed with a fatalError.

##### Disambiguate
Sometime, the return type can be ambiguous.
```swift
protocol UserService {
  func fetch(identifier: String) -> User
  func fetch(identifier: String) -> String
}

extension MockGiven where WrappedType == UserService {
  func fetch(identifier: Predicate<String>) -> Mockable<User> { mockable(identifier) }
  func fetch(identifier: Predicate<String>) -> Mockable<String> { mockable(identifier) }
}
```

 When you write `given(_service).fetch(identifier: .any)`, it is not possible to determine if the type is `Mockable<User>` or `Mockable<String>` .  
 To resolve this ambiguity and re-establish the autocompletion you must write:
 ```swift
 given(_service)
      .fetch(identifier: .any)
      .disambiguate(with: User.self)
 ```

### Use MockThen
`MockThen` is used to create assertions for your tests.
```swift
extension MockThen where WrappedType == UserService {
  func fetch(identifier: Predicate<String>) -> Verifiable<User> { verifiable(identifier) }
}
```
>⚠️ be careful to:
- call `verifiable()` with all parameters in the same order.  
- the method name must be the same as the one in the `WrappedType`.
  - exemple: **fetch(identifer:)**
- the return type must be a `Verifiable` with, as generic type, the same type as the return type of the method in the WrappedType.
  - exemple:
    - UserService.fetch(identifer:) -> User
    - MockThen.fetch(identifer:) -> Verifiable\<User>

To get it from a `Mock` use `then()` method.

##### Disambiguate
Sometime, the return type can be ambiguous.
```swift
protocol UserService {
  func fetch(identifier: String) -> User
  func fetch(identifier: String) -> String
}

extension MockThen where WrappedType == UserService {
  func fetch(identifier: Predicate<String>) -> Verifiable<User> { verifiable(identifier) }
  func fetch(identifier: Predicate<String>) -> Verifiable<String> { verifiable(identifier) }
}
```

 When you write `then(_service).fetch(identifier: .any)`, it is not possible to determine if the type is `Verifiable<User>` or `Verifiable<String>` .  
 To resolve this ambiguity and re-establish the autocompletion you must write:
 ```swift
 then(_service)
      .fetch(identifier: .any)
      .disambiguate(with: User.self)
```

### Create your own Predicates
 There is two way to create your own Predicates.

 #### With .match
 ```swift
 let myPredicate = Predicate<User>.match { user in
  user.identifier == "id"
}

myPredicate.satisfy(by: User(identifier: "id", name: "John"))
```

#### With AnyPredicate
```swift
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
```
# Playgrounds
To use playgrounds:
- open **MockSwift.xcworkspace**
- build the **MockSwiftPlayground scheme**.

# Installation
## Swift Package Manager
MockSwift is thinking to work with [Swift Package Manager](https://swift.org/package-manager/).
```swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "MyProject",
  dependencies: [
    .package(url: "https://github.com/leoture/MockSwift.git", from: "0.1.0")
  ],
  targets: [
    .testTarget(name: "MyProjectTests", dependencies: ["MockSwift"])
  ]
)
```

# Contribution
Would you like to contribute to MockSwift? Please read our [contributing guidelines](https://github.com/leoture/MockSwift/blob/master/CONTRIBUTING.md) and [code of conduct](https://github.com/leoture/MockSwift/blob/master/CODE_OF_CONDUCT.md).

# License
MockSwift is released under the MIT license. [See LICENSE](https://github.com/leoture/MockSwift/blob/master/LICENSE) for details.
