import MockSwift
import XCTest

class PropertyTests: XCTestCase {
    @Mock private var dependency: PropertyDependency
    private var property: Property!

    override func setUp() {
        property = Property(dependency: dependency)
    }

    func test_getOnly() async {
        // Given
        given(dependency).read.get.willReturn("test")

        // When
        let result = try? await property.read

        // Then
        XCTAssertEqual(result, "test")
        then(dependency).read.get.calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

    func test_getOnly_throws() async {
        // Given
        given(dependency).read.get.willThrow(DummyError.test)

        // When
        do {
            _ = try await property.read

            // Then
            XCTFail("property.read should throw")
        } catch {
            XCTAssertEqual(error as! DummyError, .test)
            then(dependency).read.get.calledOnce()
            interaction(with: dependency).ended()
            interaction(with: dependency).failOnUnusedBehaviours()
        }
    }

    func test_get() {
        // Given
        given(dependency).write.get.willReturn("test")

        // When
        let result = property.write

        // Then
        XCTAssertEqual(result, "test")
        then(dependency).write.get.calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

    func test_set() {
        // Given
        let expected = expectation(description: "waiting dependency.write.set call")
        given(dependency).write.set("test").will { _ in
            expected.fulfill()
        }

        // When
        property.write = "test"

        // Then
        wait(for: [expected], timeout: 1)
        then(dependency).write.set("test").calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }
}
