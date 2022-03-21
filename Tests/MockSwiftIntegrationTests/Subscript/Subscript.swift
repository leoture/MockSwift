import MockSwift

protocol SubscriptDependency {
    subscript(x: Int, y: Int) -> Int { get async throws }
    subscript(key: String) -> Int { get set }
}

extension Mock: SubscriptDependency where WrappedType == SubscriptDependency {
    subscript(x: Int, y: Int) -> Int {
        get async throws {
            try mockedThrowable(x, y)
        }
    }

    subscript(key: String) -> Int {
        get {
            mocked(key)
        }
        set {
            mocked(key, newValue)
        }
    }
}

extension Given where WrappedType == SubscriptDependency {
    subscript(x: Int, y: Int) -> MockableSubscript.Readable<Int> {
        mockable(x, y)
    }

    subscript(key: String) -> MockableSubscript.Writable<Int> {
        mockable(key)
    }
}

extension Then where WrappedType == SubscriptDependency {
    subscript(x: Int, y: Int) -> VerifiableSubscript.Readable<Int> {
        verifiable(x, y)
    }

    subscript(key: String) -> VerifiableSubscript.Writable<Int> {
        verifiable(key)
    }
}

struct Subscript: SubscriptDependency {
    private var dependency: SubscriptDependency

    init(dependency: SubscriptDependency) {
        self.dependency = dependency
    }

    subscript(x: Int, y: Int) -> Int {
        get async throws {
            try await dependency[x, y]
        }
    }

    subscript(key: String) -> Int {
        get {
            dependency[key]
        }
        set {
            dependency[key] = newValue
        }
    }
}
