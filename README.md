# MockSwift
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-Compatible-brightgreen)](https://github.com/apple/swift-package-manager)
[![Swift](https://img.shields.io/badge/Swift-5.1-important)](https://swift.org)
[![license MIT](https://img.shields.io/badge/license-MIT-informational)](https://github.com/leoture/MockSwift/blob/master/LICENSE)  

MockSwift is a Mock library written in Swift.

###### Table of Contents
- [Usage](#usage)
- [Playgrounds](#playgrounds)
- [Installation](#installation)
- [License](#license)

# Usage
```swift
struct User {
  let name: String
}

protocol Service {
  func function(identifier: String) -> User
}

class MyTests: XCTestCase {
  @Mock private var service: Service

  func test() {
    // Given
    given(_service)
      .function(identifier: .not(\.isEmpty))
      .willReturn(User(name: "John"))

    // When
    let john = service.function(identifier: "id")

    // Then
    then(_service)
      .function(identifier: .any)
      .called(times: 1)
  }
}
```
#### Limitations
```swift
extension Mock: Service where WrappedType == Service {
  func function(identifier: String) -> User {
    mocked(identifier)
  }
}

extension MockGiven where WrappedType == Service {
  func function(identifier: Predicate<String>) -> Mockable<User> {
    mockable(identifier)
  }
}

extension MockThen where WrappedType == Service {
  func function(identifier: Predicate<String>) -> Verifiable<User> {
    verifiable(identifier)
  }
}
```
# Playgrounds
To use playgrounds, open **MockSwift.xcworkspace**, build
the **MockSwiftPlayground scheme** and choose **View > Debug Area > Show Debug Area**.

# Installation
## Swift Package Manager
TODO
```swift
// swift-tools-version:5.0

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

## Manually
TODO

# License
MockSwift is released under the MIT license. [See LICENSE](https://github.com/leoture/MockSwift/blob/master/LICENSE) for details.
