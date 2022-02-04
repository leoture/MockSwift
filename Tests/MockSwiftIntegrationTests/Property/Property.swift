import MockSwift

protocol PropertyDependency {
    var read: String { get }
    var write: String { get set }
}

extension Mock: PropertyDependency where WrappedType == PropertyDependency {
    var read: String { mocked() }
    var write: String {
        get { mocked() }
        set { mocked(newValue) }
    }
}

extension Given where WrappedType == PropertyDependency {
    var read: MockableProperty.Readable<String> { mockable() }
    var write: MockableProperty.Writable<String> { mockable() }
}

extension Then where WrappedType == PropertyDependency {
    var read: VerifiableProperty.Readable<String> { verifiable() }
    var write: VerifiableProperty.Writable<String> { verifiable() }
}

struct Property: PropertyDependency {
    private var dependency: PropertyDependency

    init(dependency: PropertyDependency) {
        self.dependency = dependency
    }

    var read: String {
        dependency.read
    }

    var write: String {
        get {
            dependency.write
        }
        set {
            dependency.write = newValue
        }
    }
}
