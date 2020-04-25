<p align="center">
  <img src="https://raw.githubusercontent.com/leoture/MockSwift/master/MockSwift.svg?sanitize=true" alt="MockSwift" width="256">  
</p>

Welcome to MockSwift!  
=======
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/e71430b5e4b84b818cffadaaad3ba57c)](https://app.codacy.com/manual/jordhan.leoture/MockSwift?utm_source=github.com&utm_medium=referral&utm_content=leoture/MockSwift&utm_campaign=Badge_Grade_Dashboard)
[![Release](https://img.shields.io/github/v/release/leoture/MockSwift?color=red)](https://github.com/leoture/MockSwift/releases)
[![Build Status](https://github.com/leoture/MockSwift/workflows/Master/badge.svg?branch=master)](https://github.com/leoture/MockSwift/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/1a16a774c75308d97f27/maintainability)](https://codeclimate.com/github/leoture/MockSwift/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1a16a774c75308d97f27/test_coverage)](https://codeclimate.com/github/leoture/MockSwift/test_coverage)
[![documentation](https://raw.githubusercontent.com/leoture/MockSwift/master/docs/badge.svg?sanitize=true)](https://leoture.github.io/MockSwift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-brightgreen)](https://github.com/apple/swift-package-manager)
[![Swift](https://img.shields.io/badge/Swift-5.2-important)](https://swift.org)
[![license MIT](https://img.shields.io/badge/license-MIT-informational)](https://github.com/leoture/MockSwift/blob/master/LICENSE)  

**MockSwift** allows you to [**write mocks**](#write-mocks) and [**make better tests**](#make-better-tests). Because **MockSwift** is an **open source** library **100%** written in **Swift**, it is **AVAILABLE ON ALL PLATFORMS**.    
Initially MockSwift is inspired by [Mockito](https://site.mockito.org).  


###### Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Documentation](#documentation)
- [Playgrounds](#playgrounds)
- [Contribution](#contribution)
- [License](#license)

# Features
Actually MockSwift supports:
- **Mocking**
  - [x] **protocol** (methods, properties, subscripts)
  - [ ] class ([v2](https://github.com/leoture/MockSwift/projects/2))
  - [ ] struct ([v2](https://github.com/leoture/MockSwift/projects/2))
  - [ ] enum ([v2](https://github.com/leoture/MockSwift/projects/2))
- **Call verification**
  - [x] **protocol** (methods, properties, subscripts)
  - [ ] class ([v2](https://github.com/leoture/MockSwift/projects/2))
  - [ ] struct ([v2](https://github.com/leoture/MockSwift/projects/2))
  - [ ] enum ([v2](https://github.com/leoture/MockSwift/projects/2))
- [x] **Generics**
- [x] **Parameters matching**
- [x] **Default values for Types**

#### CHANGELOG
You can see all changes and new features [here](https://github.com/leoture/MockSwift/blob/master/CHANGELOG.md).

# Installation
## Swift Package Manager
MockSwift has been designed to work with [Swift Package Manager](https://swift.org/package-manager/).
```swift
// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "MyProject",
  dependencies: [
    .package(url: "https://github.com/leoture/MockSwift.git", from: "0.6.0")
  ],
  targets: [
    .testTarget(name: "MyProjectTests", dependencies: ["MockSwift"])
  ]
)
```

# Usage
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

And you want to test this `UserCore` class.
```swift
class UserCore {
  private let service: UserService

  init(_ service: UserService) {
    self.service = service
  }

  func fetchCurrentUser() -> User {
    service.fetch(identifier: "current")
  }
}
```

## Make better tests

Now, with MockSwift, you can use a mocked `UserService` in your tests with the `@Mock` annotation.
```swift
@Mock private var service: UserService

// equivalent to

private var service: UserService = Mock()
```

And easly configure it to fully test `UseCore`.
```swift
class UserCoreTests: XCTestCase {

  private var core: UserCore!
  @Mock private var service: UserService

  override func setUp() {
    core = UserCore(service)
  }

  func test_fetchCurrentUser() {
    // Given
    let expectedUser = User(identifier: "current", name: "John")

    given(service).fetch(identifier: .any()).willReturn(expectedUser)

    // When
    let user = core.fetchCurrentUser()

    // Then
    then(service).fetch(identifier: .any()).called()
    XCTAssertEqual(user, expectedUser)
  }
}
```

### Given
`given()` enables you to define behaviours.  
example:
```swift
given(service).fetch(identifier: .any()).willReturn(expectedUser)

// equivalent to

given(service) {
  $0.fetch(identifier: .any()).willReturn(expectedUser)
}
```

```swift
given(service) {
  $0.fetch(identifier: "current")
    .willReturn(expectedUser, expectedUser1, expectedUser2)

  $0.fetch(identifier: .match(when: \.isEmpty))
    .will { (params) -> User in
            // do something else
            return expectedUser
          }
}
```

you can also define behaviours when you instantiate the mock.

```swift
@Mock({
  $0.fetch(identifier: .any()).willReturn(expectedUser)
})
private var service: UserService
```
### Then
`then()` enables you to verify calls.  
example:
```swift
then(service).fetch(identifier: .any()).called()

// equivalent to

then(service) {
  $0.fetch(identifier: .any()).called()
}
```
```swift
then(service) {
  $0.fetch(identifier: "current").called(times: >=2)

  $0.fetch(identifier: =="").called(times: 0)
}
```
### Stubs
In MockSwift, stubs are default values that are returned when no behaviours has been found.
#### Global Stubs
You can define a **global stub** for any type.
It will concern **all mocks** you will use in **every tests**.
```swift
extension User: GlobalStub {
  static func stub() -> User {
    User(identifier: "id", name: "John")
  }
}
```
#### Local Stubs
You can also define a **stub localy** for any type.
It will concern only the **current mock**.
```swift
@Mock(localStubs: [
      User.self => User(identifier: "id", name: "John")
])
private var service: UserService
```

### Strategy
The default strategy is to find behaviour defined with `given()`. If no behaviour is found, it will return a local stub. If no local stub is found, it will return a global stub.

```swift
@Mock private var service: UserService

// equivalent to

@Mock(strategy: .default)
private var service: UserService

// equivalent to

@Mock(strategy: [.given, .localStubs, .globalStubs])
private var service: UserService
```

You can change the order of the strategy list or remove items as you want.

## Write mocks
### Automatically
MockSwift provides a [stencil template](https://github.com/leoture/MockSwift/blob/master/Templates/MockSwift.stencil) for [sourcery](https://github.com/krzysztofzablocki/Sourcery). You can use the `AutoMockable` annotation to generate code.
```swift
// sourcery: AutoMockable
protocol UserService {
  func fetch(identifier: String) -> User
}
```

To generate code at every build, you can add a build phase before `Compile Sources`.
```
sourcery \
--sources MyLibrary \
--templates MyLibraryTests/path/to/MockSwift.stencil \
--output MyLibraryTests/path/to/GeneratedMocks.swift \
--args module=MyLibrary
```

### Manually
To enable MockSwift for UserService type, you have to extend **Mock**.
```swift
extension Mock: UserService where WrappedType == UserService {
  public func fetch(identifier: String) -> User {
    mocked(identifier)
  }
}
```

To allow behaviour definition through `given()` method, you have to extend **Given**.
```swift
extension Given where WrappedType == UserService {
  public func fetch(identifier: Predicate<String>) -> Mockable<User> {
    mockable(identifier)
  }
  public func fetch(identifier: String) -> Mockable<User> {
    mockable(identifier)
  }
}
```

To allow call verification through `then()` method, you have to extend **Then**.
```swift
extension Then where WrappedType == UserService {
  public func fetch(identifier: Predicate<String>) -> Verifiable<User> {
    verifiable(identifier)
  }
  public func fetch(identifier: String) -> Verifiable<User> {
    verifiable(identifier)
  }
}
```
# Documentation
If you need more details about the API, you can check out our [API documentation](https://leoture.github.io/MockSwift/) or our [GitBook](https://mockswift.gitbook.io/mockswift/).
# Playgrounds
This project contains playgrounds that can help you experiment **MockSwift** .  
To use playgrounds:
- open **MockSwift.xcworkspace**
- build the **MockSwiftPlayground scheme**.

# Contribution
Would you like to contribute to MockSwift? Please read our [contributing guidelines](https://github.com/leoture/MockSwift/blob/master/CONTRIBUTING.md) and [code of conduct](https://github.com/leoture/MockSwift/blob/master/CODE_OF_CONDUCT.md).

# License
MockSwift is released under the MIT license. [See LICENSE](https://github.com/leoture/MockSwift/blob/master/LICENSE) for details.

# Credits
[![Thanks to JetBrains](https://raw.githubusercontent.com/leoture/MockSwift/master/jetbrains.svg?sanitize=true)](https://www.jetbrains.com/?from=MockSwift)
