<img src="https://github.com/leoture/MockSwift/blob/master/MockSwift.svg" alt="MockSwift" width="32" height="32"> Welcome to MockSwift!
=======
[![Build Status](https://travis-ci.com/leoture/MockSwift.svg?token=7mHp1J41yAdss7UzTesf&branch=master)](https://travis-ci.com/leoture/MockSwift)
[![codecov](https://codecov.io/gh/leoture/MockSwift/branch/master/graph/badge.svg)](https://codecov.io/gh/leoture/MockSwift)
[![documentation](https://github.com/leoture/MockSwift/blob/master/docs/badge.svg)](https://leoture.github.io/MockSwift)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-brightgreen)](https://github.com/apple/swift-package-manager)
[![Swift](https://img.shields.io/badge/Swift-5.1-important)](https://swift.org)
[![license MIT](https://img.shields.io/badge/license-MIT-informational)](https://github.com/leoture/MockSwift/blob/master/LICENSE)  

MockSwift is a Mock library written in Swift for Swift.  
###### Table of Contents
- [Installation](#installation)
- [Usage](#usage)
- [Playgrounds](#playgrounds)
- [Contribution](#contribution)
- [License](#license)

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

# Usage

If you need more details about the API, you can check out our [API documentation](https://leoture.github.io/MockSwift/) or our [GitBook](https://mockswift.gitbook.io/mockswift/).

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

### Basic usage
Now, you can use `UserService` into your tests with the `@Mock` annotation.
```swift
class MyTests: XCTestCase {
  @Mock private var service: UserService

  func test_fetch() {
    // Given
    let expectedUser = User(identifier: "id", name: "John")

    given(service)
      .fetch(identifier: .any)
      .willReturn(expectedUser)

    // When
    let user = service.fetch(identifier: "id")

    // Then
    then(service)
      .fetch(identifier: .any)
      .called()
    XCTAssertEqual(user, expectedUser)
  }
}
```

### MockDefault
You can define a default value for any type.  
This value will be returned for any mocked method returning this type, only if no behaviour has been defined.  
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

# Playgrounds
This project contains playgrounds that can help you experiment **MockSwift** .  
To use playgrounds:
- open **MockSwift.xcworkspace**
- build the **MockSwiftPlayground scheme**.

# Contribution
Would you like to contribute to MockSwift? Please read our [contributing guidelines](https://github.com/leoture/MockSwift/blob/master/CONTRIBUTING.md) and [code of conduct](https://github.com/leoture/MockSwift/blob/master/CODE_OF_CONDUCT.md).

# License
MockSwift is released under the MIT license. [See LICENSE](https://github.com/leoture/MockSwift/blob/master/LICENSE) for details.
