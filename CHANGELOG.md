# Changelog

[Unrelease](#Unrelease)

##### 0.x Releases
- [0.6.0](#0.6.0)
- [0.5.0](#0.5.0)
- [0.4.0](#0.4.0)
- [0.3.0](#0.3.0)
- [0.2.0](#0.2.0)
- [0.1.0](#0.1.0)

---
## Unrelease
[Compare](https://github.com/leoture/MockSwift/compare/v0.6.0...HEAD)
#### Added
- Add called with order [#102](https://github.com/leoture/MockSwift/pull/102) by [Jordhan Leoture](https://github.com/leoture)
- Add Interaction.ended() [#101](https://github.com/leoture/MockSwift/pull/101) by [Jordhan Leoture](https://github.com/leoture)

#### Changed

#### Deprecated

#### Removed

#### Fixed

#### Security

---
## [0.6.0](https://github.com/leoture/MockSwift/releases/tag/v0.6.0) - 2020-03-11
[Compare](https://github.com/leoture/MockSwift/compare/v0.6.0...HEAD)
#### Added
- Add identical Predicate [#88](https://github.com/leoture/MockSwift/pull/88) by [Jordhan Leoture](https://github.com/leoture)
- Add syntactic sugar for Predicate on Comparables [#87](https://github.com/leoture/MockSwift/pull/87) by [Jordhan Leoture](https://github.com/leoture)
- NSObject as AnyPredicate [#83](https://github.com/leoture/MockSwift/pull/83) by [Jordhan Leoture](https://github.com/leoture)
- Supports subscript [#80](https://github.com/leoture/MockSwift/pull/80) by [Jordhan Leoture](https://github.com/leoture)
- Add Strategy configuration [#78](https://github.com/leoture/MockSwift/pull/78) by [Jordhan Leoture](https://github.com/leoture)

#### Changed
- Rename MockThen to Then [#89](https://github.com/leoture/MockSwift/pull/89) by [Jordhan Leoture](https://github.com/leoture)
- Rename MockGiven to Given [#89](https://github.com/leoture/MockSwift/pull/89) by [Jordhan Leoture](https://github.com/leoture)
- Rename moreThan to greaterThan [#85](https://github.com/leoture/MockSwift/pull/85) by [Jordhan Leoture](https://github.com/leoture)

---
## [0.5.0](https://github.com/leoture/MockSwift/releases/tag/v0.5.0) - 2020-01-25
[Compare](https://github.com/leoture/MockSwift/compare/v0.4.0...v0.5.0)
#### Added
- Add Mock init with block stubs [#74](https://github.com/leoture/MockSwift/pull/74) by [Jordhan Leoture](https://github.com/leoture)
- Add Mock init with given block [#72](https://github.com/leoture/MockSwift/pull/72) by [Jordhan Leoture](https://github.com/leoture)
- Add MockableProperty [#70](https://github.com/leoture/MockSwift/pull/70) by [Jordhan Leoture](https://github.com/leoture)
- Add VerifiableProperty [#70](https://github.com/leoture/MockSwift/pull/70) by [Jordhan Leoture](https://github.com/leoture)
- Template sourcery for property [#70](https://github.com/leoture/MockSwift/pull/70) by [Jordhan Leoture](https://github.com/leoture)
- Template sourcery for MockableProperty [#70](https://github.com/leoture/MockSwift/pull/70) by [Jordhan Leoture](https://github.com/leoture)
- Template sourcery for VerifiableProperty [#70](https://github.com/leoture/MockSwift/pull/70) by [Jordhan Leoture](https://github.com/leoture)

#### Changed
- Rename MockDefault to GlobalStub [#69](https://github.com/leoture/MockSwift/pull/69) by [Jordhan Leoture](https://github.com/leoture)

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
