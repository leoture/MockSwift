# Changelog

[Unrelease](#Unrelease)

##### 0.x Releases  
- [0.4.0](#0.4.0)
- [0.3.0](#0.3.0)
- [0.2.0](#0.2.0)
- [0.1.0](#0.1.0)

---
## Unrelease
[Compare](https://github.com/leoture/MockSwift/compare/v0.4.0...HEAD)
#### Added

#### Changed

#### Deprecated

#### Removed

#### Fixed

#### Security

---
## [0.4.0](https://github.com/leoture/MockSwift/releases/tag/v0.4.0) - 2019-11-12
[Compare](https://github.com/leoture/MockSwift/compare/v0.3.0...v0.4.0)
#### Added
- Add receivedParameters and callCount to Verifiable [#50](https://github.com/leoture/MockSwift/pull/50) by [Jordhan Leoture](https://github.com/leoture)
- Generate Mock with generics [#43](https://github.com/leoture/MockSwift/pull/43) by [Jordhan Leoture](https://github.com/leoture)

#### Changed
- Template sourcery only generates Mock with AutoMockable annotation [#43](https://github.com/leoture/MockSwift/pull/43) by [Jordhan Leoture](https://github.com/leoture)
- The Input type of Predicate.match and Predicate.any can be disambiguate [#58](https://github.com/leoture/MockSwift/pull/58) by [Jordhan Leoture](https://github.com/leoture)

#### Fixed
- Fix generated mock when a parameter is escaping [#51](https://github.com/leoture/MockSwift/pull/51) by [Jordhan Leoture](https://github.com/leoture)

---
## [0.3.0](https://github.com/leoture/MockSwift/releases/tag/v0.3.0) - 2019-10-16
[Compare](https://github.com/leoture/MockSwift/compare/v0.2.0...v0.3.0)
#### Added
- Add Predicate .match(description:keyPath:) [#38](https://github.com/leoture/MockSwift/pull/38) by [Jordhan Leoture](https://github.com/leoture)
- Add willThrow [#37](https://github.com/leoture/MockSwift/pull/37) by [Jordhan Leoture](https://github.com/leoture)
- Add willReturn with a List [#36](https://github.com/leoture/MockSwift/pull/36) by [Jordhan Leoture](https://github.com/leoture)
- Add Predicates with Comparables [#28](https://github.com/leoture/MockSwift/pull/28) by [Jordhan Leoture](https://github.com/leoture)
- Add Predicates .isTrue() & .isFalse() [#33](https://github.com/leoture/MockSwift/pull/33) by [Jordhan Leoture](https://github.com/leoture)
- Add Predicate .not() [#33](https://github.com/leoture/MockSwift/pull/33) by [Jordhan Leoture](https://github.com/leoture)
- Add Predicate .isNil() [#33](https://github.com/leoture/MockSwift/pull/33) by [Jordhan Leoture](https://github.com/leoture)

#### Changed
- mocked() with optionals [#32](https://github.com/leoture/MockSwift/pull/32) by [Jordhan Leoture](https://github.com/leoture)

---
## [0.2.0](https://github.com/leoture/MockSwift/releases/tag/v0.2.0) - 2019-09-29
[Compare](https://github.com/leoture/MockSwift/compare/v0.1.0...v0.2.0)
#### Added
- New Logo by [Jordhan Leoture](https://github.com/leoture)
- Template sourcery [#20](https://github.com/leoture/MockSwift/pull/20) by [Jordhan Leoture](https://github.com/leoture)

#### Changed
- Given with wrapped type [#18](https://github.com/leoture/MockSwift/pull/18) by [Jordhan Leoture](https://github.com/leoture)
- Then with wrapped type [#21](https://github.com/leoture/MockSwift/pull/21) by [Jordhan Leoture](https://github.com/leoture)
- Given & Then with completion block [#22](https://github.com/leoture/MockSwift/pull/22) by [Jordhan Leoture](https://github.com/leoture)

---
## [0.1.0](https://github.com/leoture/MockSwift/releases/tag/v0.1.0) - 2019-08-22
- Initial release by [Jordhan Leoture](https://github.com/leoture)
