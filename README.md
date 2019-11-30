<p align="center">
  <img src="https://raw.githubusercontent.com/leoture/MockSwift/master/MockSwift.svg?sanitize=true" alt="MockSwift" width="256">  
</p>

Welcome to MockSwift!  
=======
[![Release](https://img.shields.io/github/v/release/leoture/MockSwift?color=red)](https://github.com/leoture/MockSwift/releases)
[![Build Status](https://github.com/leoture/MockSwift/workflows/Master/badge.svg?branch=master)](https://github.com/leoture/MockSwift/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/1a16a774c75308d97f27/maintainability)](https://codeclimate.com/github/leoture/MockSwift/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/1a16a774c75308d97f27/test_coverage)](https://codeclimate.com/github/leoture/MockSwift/test_coverage)
[![documentation](https://raw.githubusercontent.com/leoture/MockSwift/master/docs/badge.svg?sanitize=true)](https://leoture.github.io/MockSwift)
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
    .package(url: "https://github.com/leoture/MockSwift.git", from: "0.4.0")
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
      .fetch(identifier: .any())
      .willReturn(expectedUser)

    // When
    let user = service.fetch(identifier: "id")

    // Then
    then(service)
      .fetch(identifier: .any())
      .called()
    XCTAssertEqual(user, expectedUser)
  }
}
```

### GlobalStub
You can define a global stub for any type.  
This value will be returned for any mocked method returning this type, only if no behaviour has been defined.  
```swift
extension User: GlobalStub {
  static func stub() -> User {
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

# Credits
[![Thanks to JetBrains](https://raw.githubusercontent.com/leoture/MockSwift/master/jetbrains.svg?sanitize=true)](https://www.jetbrains.com/?from=MockSwift)
