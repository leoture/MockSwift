# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Build
swift build

# Run all tests
swift test

# Run a single test
swift test --filter MockSwiftTests.MockTests/test_mocked

# Linux testing (requires Docker)
docker-compose up
```

## Architecture

MockSwift is a pure Swift mocking library with no external dependencies. It is structured around four top-level concerns:

### Core API (`Sources/MockSwift/Core/`)

The user-facing API has four components that work together:

- **`Mock<WrappedType>`** – A property wrapper (also usable as `@Mock`) that wraps any mockable type. It implements `CallRegister`, `BehaviourRegister`, and `StubRegister`, making it the central hub that the other three components communicate through.
- **`Given<WrappedType>`** – Returned by the global `given()` function. Configures expected behaviors (stubs) on a mock before a test runs.
- **`Then<WrappedType>`** – Returned by the global `then()` function. Verifies that calls happened as expected after a test runs.
- **`Interaction<WrappedType>`** – Returned by `interaction(with:)`. Provides higher-level assertions like `ended()` (no unexpected calls) and `failOnUnusedBehaviours()`.

The typical test flow is: annotate with `@Mock` → configure with `given()` → exercise SUT → verify with `then()` / `interaction(with:)`.

### Behavior Resolution (`Sources/MockSwift/Strategies/`)

When a mocked method is called, a `StrategyFactory` selects a `Strategy` to resolve the return value. Strategies are tried in order: `.given` (explicit stubs), `.localStubs`, `.globalStubs`. This chain is customizable per mock. Unresolved calls fall through to `UnresolvedStrategy`, which triggers the error handler.

### Predicate Matching (`Sources/MockSwift/Predicates/`)

`Predicate<Input>` is the parameter matching system used in `given()` and `then()` calls. It is constructed via static factories (`.any()`, `.match { ... }`, `.not()`, etc.) and extended for `Equatable`, `Comparable`, `Optional`, `Bool`, and `AnyObject` types.

### Registers (`Sources/MockSwift/Registers/`)

Internal storage:
- **`CallRegister`** – Records actual calls with timestamps.
- **`BehaviourRegister`** – Stores configured behaviors (from `given()`).
- **`StubRegister`** – Stores global/local stub values.

`Mock` conforms to all three register protocols and is passed to `Given`, `Then`, and `Interaction` at construction time.

## Test Organization

- `Tests/MockSwiftTests/` – Unit tests with `@testable import MockSwift`. Mirror source structure (`Core/`, `Predicates/`, `Strategies/`, `Registers/`).
- `Tests/MockSwiftIntegrationTests/` – Integration tests covering real-world usage of functions, properties, and subscripts.

Test method naming: `test_<method>_<scenario>()` or simply `test_<method>()`.

## Key Conventions

- **Swift API Design Guidelines** are followed strictly. All PRs must comply.
- **MARK comments** organize sections within files: `// MARK: - Properties`, `// MARK: - Init`, `// MARK: - Public Methods`.
- **Documentation comments** (`///`) with parameter descriptions are required on all public API.
- **One main type per file**; extensions on core types live in separate files.
- **No SwiftLint** is configured — style is enforced through code review.
- All PRs must reference an issue. CI must pass before review begins.
- Contributors must sign off commits under the Developer Certificate of Origin 1.1.
