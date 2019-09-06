#if !canImport(ObjectiveC)
import XCTest

extension AnyPredicateEquatableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AnyPredicateEquatableTests = [
        ("test_satify_Bool", test_satify_Bool),
        ("test_satify_Int", test_satify_Int),
        ("test_satify_String", test_satify_String),
        ("test_satisfy_shouldReturnFalseIfNotEquals", test_satisfy_shouldReturnFalseIfNotEquals),
        ("test_satisfy_shouldReturnTrueIfEquals", test_satisfy_shouldReturnTrueIfEquals),
    ]
}

extension DefaultFunctionBehaviourTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__DefaultFunctionBehaviourTests = [
        ("test_handle_shouldReturnDefaultCustom", test_handle_shouldReturnDefaultCustom),
        ("test_handle_shouldReturnNullOnUnknownType", test_handle_shouldReturnNullOnUnknownType),
    ]
}

extension FunctionBehaviourRegisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FunctionBehaviourRegisterTests = [
        ("test_recordedBehaviours_shouldReturnDefaultFunctionBehaviourWhenNoMatchs", test_recordedBehaviours_shouldReturnDefaultFunctionBehaviourWhenNoMatchs),
        ("test_recordedBehaviours_shouldReturnFunctionBehaviourMatched", test_recordedBehaviours_shouldReturnFunctionBehaviourMatched),
    ]
}

extension FunctionBehaviourTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FunctionBehaviourTests = [
        ("test_handle_shouldCallHandlerWithCorrectParameters", test_handle_shouldCallHandlerWithCorrectParameters),
        ("test_handle_shouldReturnValueFormHandler", test_handle_shouldReturnValueFormHandler),
    ]
}

extension FunctionCallRegisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FunctionCallRegisterTests = [
        ("test_recordedCalls_shouldReturnEmptyWhenNoFunctionCall", test_recordedCalls_shouldReturnEmptyWhenNoFunctionCall),
        ("test_recordedCalls_shouldReturnEmptyWhenNoFunctionCallMatched", test_recordedCalls_shouldReturnEmptyWhenNoFunctionCallMatched),
        ("test_recordedCalls_shouldReturnFunctionCallsMatched", test_recordedCalls_shouldReturnFunctionCallsMatched),
    ]
}

extension FunctionIdentifierTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FunctionIdentifierTests = [
        ("test_callDescription_withNoParameters", test_callDescription_withNoParameters),
        ("test_callDescription_withParameters", test_callDescription_withParameters),
    ]
}

extension MockDefaultExtensionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockDefaultExtensionTests = [
        ("test_default_Bool", test_default_Bool),
        ("test_default_Int", test_default_Int),
        ("test_default_String", test_default_String),
    ]
}

extension MockDefaultIntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockDefaultIntegrationTests = [
        ("test_function_shouldReturnDefaultCustom", test_function_shouldReturnDefaultCustom),
        ("test_functionBool_shouldReturnDefaultBool", test_functionBool_shouldReturnDefaultBool),
        ("test_functionInt_shouldReturnDefaultInt", test_functionInt_shouldReturnDefaultInt),
        ("test_functionString_shouldReturnDefaultString", test_functionString_shouldReturnDefaultString),
        ("test_functionVoid_shouldReturnVoid", test_functionVoid_shouldReturnVoid),
    ]
}

extension MockGivenIntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockGivenIntegrationTests = [
        ("test_function_shouldReturnDefaultValueIfNoMatch", test_function_shouldReturnDefaultValueIfNoMatch),
        ("test_function_shouldReturnValueFromWillCompletion", test_function_shouldReturnValueFromWillCompletion),
        ("test_function_shouldReturnValueFromWillReturnValue", test_function_shouldReturnValueFromWillReturnValue),
    ]
}

extension MockTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockTests = [
        ("test_mocked_shouldRecordCallIntoCallRegister", test_mocked_shouldRecordCallIntoCallRegister),
        ("test_mocked_shouldReturnValueFromBehaviour", test_mocked_shouldReturnValueFromBehaviour),
        ("test_mockedVoid_shouldCallBehaviour", test_mockedVoid_shouldCallBehaviour),
        ("test_mockedVoid_shouldRecordCallIntoCallRegister", test_mockedVoid_shouldRecordCallIntoCallRegister),
    ]
}

extension MockThenIntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockThenIntegrationTests = [
        ("test_function_shouldBeCalledWhenParametersMatched", test_function_shouldBeCalledWhenParametersMatched),
    ]
}

extension MockableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockableTests = [
        ("test_disambiguate_shouldReturnSameMockableWithDisambiguatedReturnType", test_disambiguate_shouldReturnSameMockableWithDisambiguatedReturnType),
        ("test_will_shouldCorrectlyRegisterBahaviour", test_will_shouldCorrectlyRegisterBahaviour),
        ("test_willReturn_shouldCorrectlyRegisterBahaviour", test_willReturn_shouldCorrectlyRegisterBahaviour),
    ]
}

extension PredicateComparableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PredicateComparableTests = [
        ("test_equals_description", test_equals_description),
        ("test_equals_shouldReturnFalseIfComparisonReturnFalse", test_equals_shouldReturnFalseIfComparisonReturnFalse),
        ("test_equals_shouldReturnTrueIfComparisonReturnTrue", test_equals_shouldReturnTrueIfComparisonReturnTrue),
        ("test_superior_description", test_superior_description),
        ("test_superior_shouldReturnFalseIfComparisonReturnFalse", test_superior_shouldReturnFalseIfComparisonReturnFalse),
        ("test_superior_shouldReturnTrueIfComparisonReturnTrue", test_superior_shouldReturnTrueIfComparisonReturnTrue),
    ]
}

extension PredicateTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PredicateTests = [
        ("test_description_withAny", test_description_withAny),
        ("test_description_withMatch", test_description_withMatch),
        ("test_satisfy_shouldReturnFalseIfInputNotMatched", test_satisfy_shouldReturnFalseIfInputNotMatched),
        ("test_satisfy_shouldReturnFalseIfInputNotMatchedByAnyPredicate", test_satisfy_shouldReturnFalseIfInputNotMatchedByAnyPredicate),
        ("test_satisfy_shouldReturnFalseIfInputNotMatchedReference", test_satisfy_shouldReturnFalseIfInputNotMatchedReference),
        ("test_satisfy_shouldReturnTrue", test_satisfy_shouldReturnTrue),
        ("test_satisfy_shouldReturnTrueIfInputMatched", test_satisfy_shouldReturnTrueIfInputMatched),
        ("test_satisfy_shouldReturnTrueIfInputMatchedByAnyPredicate", test_satisfy_shouldReturnTrueIfInputMatchedByAnyPredicate),
        ("test_satisfy_shouldReturnTrueIfInputMatchedReference", test_satisfy_shouldReturnTrueIfInputMatchedReference),
        ("test_satisfy_withAnyshouldReturnFalseIfInputIsNotTheSameType", test_satisfy_withAnyshouldReturnFalseIfInputIsNotTheSameType),
        ("test_satisfy_withMatchShouldReturnFalseIfInputIsNotTheSameType", test_satisfy_withMatchShouldReturnFalseIfInputIsNotTheSameType),
    ]
}

extension VerifiableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VerifiableTests = [
        ("test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatched", test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatched),
        ("test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimes", test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimes),
        ("test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimesExactly", test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimesExactly),
        ("test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatched", test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatched),
        ("test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimes", test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimes),
        ("test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimesExactly", test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimesExactly),
        ("test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType", test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnyPredicateEquatableTests.__allTests__AnyPredicateEquatableTests),
        testCase(DefaultFunctionBehaviourTests.__allTests__DefaultFunctionBehaviourTests),
        testCase(FunctionBehaviourRegisterTests.__allTests__FunctionBehaviourRegisterTests),
        testCase(FunctionBehaviourTests.__allTests__FunctionBehaviourTests),
        testCase(FunctionCallRegisterTests.__allTests__FunctionCallRegisterTests),
        testCase(FunctionIdentifierTests.__allTests__FunctionIdentifierTests),
        testCase(MockDefaultExtensionTests.__allTests__MockDefaultExtensionTests),
        testCase(MockDefaultIntegrationTests.__allTests__MockDefaultIntegrationTests),
        testCase(MockGivenIntegrationTests.__allTests__MockGivenIntegrationTests),
        testCase(MockTests.__allTests__MockTests),
        testCase(MockThenIntegrationTests.__allTests__MockThenIntegrationTests),
        testCase(MockableTests.__allTests__MockableTests),
        testCase(PredicateComparableTests.__allTests__PredicateComparableTests),
        testCase(PredicateTests.__allTests__PredicateTests),
        testCase(VerifiableTests.__allTests__VerifiableTests),
    ]
}
#endif
