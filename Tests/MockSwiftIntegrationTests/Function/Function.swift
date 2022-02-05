import MockSwift

enum FailError: Error, Equatable {
    case test
}

protocol FunctionDependency {
    func echo(_ value: String) -> String
    func exec(with value: String, _ completion: @escaping (String) -> Int) -> Int
    func fail() throws
}

extension Mock: FunctionDependency where WrappedType == FunctionDependency {
    func echo(_ value: String) -> String {
        mocked(value)
    }

    func exec(with value: String, _ completion: @escaping (String) -> Int) -> Int {
        mocked(value, completion)
    }

    func fail() throws {
        try mockedThrowable()
    }

}

extension Given where WrappedType == FunctionDependency {
    func echo(_ value: String) -> Mockable<String> {
        mockable(value)
    }

    func exec(with value: String, _ completion: Predicate<(String) -> Int>) -> Mockable<Int> {
        mockable(value, completion)
    }

    func fail() -> Mockable<Void>{
        mockable()
    }
}

extension Then where WrappedType == FunctionDependency {
    func echo(_ value: String) -> Verifiable<String> {
        verifiable(value)
    }

    func exec(with value: String, _ completion: Predicate<(String) -> Int>) -> Verifiable<Int> {
        verifiable(value, completion)
    }

    func fail() -> Verifiable<Void>{
        verifiable()
    }
}

struct Function: FunctionDependency {
    private var dependency: FunctionDependency

    init(dependency: FunctionDependency) {
        self.dependency = dependency
    }

    func echo(_ value: String) -> String {
        dependency.echo(value)
    }

    func exec(with value: String, _ completion: @escaping (String) -> Int) -> Int {
        dependency.exec(with: value, completion)
    }

    func fail() throws {
        try dependency.fail()
    }
}
