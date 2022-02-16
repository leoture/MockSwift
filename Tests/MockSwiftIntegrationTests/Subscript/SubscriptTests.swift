import MockSwift
import XCTest

class SubscriptTests: XCTestCase {
    @Mock private var dependency: SubscriptDependency
    private var subject: Subscript!

    override func setUp() {
        subject = Subscript(dependency: dependency)
    }

    func test_getOnly() async {
        // Given
        given(dependency)[1, 2].get.willReturn(3)

        // When
        let result = try? await subject[1, 2]

        // Then
        XCTAssertEqual(result, 3)
        then(dependency)[1, 2].get.calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

    func test_getOnly_throws() async {
        // Given
        given(dependency)[1, 2].get.willThrow(DummyError.test)

        // When
        do {
            _ = try await subject[1, 2]
            XCTFail("subject[1, 2] should throws")
        } catch {
            XCTAssertEqual(error as! DummyError, .test)
        }

        // Then
        then(dependency)[1, 2].get.calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

    func test_get() {
        // Given
        given(dependency)["key"].get.willReturn(3)

        // When
        let result = subject["key"]

        // Then
        XCTAssertEqual(result, 3)
        then(dependency)["key"].get.calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

    func test_set() {
        // Given
        let expected = expectation(description: "waiting dependency[key:].set call")
        given(dependency)["key"].set(1).will { _ in
            expected.fulfill()
        }

        // When
        subject["key"] = 1

        // Then

        wait(for: [expected], timeout: 1)
        then(dependency)["key"].set(1).calledOnce()
        interaction(with: dependency).ended()
        interaction(with: dependency).failOnUnusedBehaviours()
    }

}
