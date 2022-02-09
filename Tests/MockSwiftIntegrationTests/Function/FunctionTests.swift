import MockSwift
import XCTest

class FunctionTests: XCTestCase {
    @Mock private var dependency: FunctionDependency
    private var function: Function!

    override func setUp() {
        function = Function(dependency: dependency)
    }

    func test_echo() {
        // Given
        given(dependency).echo("test").willReturn("test test")

        // When
        let result = function.echo("test")

        // Then
        XCTAssertEqual(result, "test test")
        then(dependency).echo("test").calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

    func test_exec() {
        // Given
        given(dependency).exec(with: "test", .match { $0("test") == 1 }).willReturn(2)

        // When
        let result = function.exec(with: "test") { _ in 1 }

        // Then
        XCTAssertEqual(result, 2)
        then(dependency).exec(with: "test", .match { $0("test") == 1 }).calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

    func test_fail() {
        // Given
        given(dependency).fail().willThrow(DummyError.test)

        // When
        XCTAssertThrowsError(try function.fail(), "") { error in
            XCTAssertEqual(error as! DummyError, .test)
        }

        // Then
        then(dependency).fail().calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

}
