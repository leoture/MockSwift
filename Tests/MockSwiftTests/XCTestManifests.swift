#if !canImport(ObjectiveC)
import XCTest

extension AnyPredicateEquatableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__AnyPredicateEquatableTests = [
        ("test_satify_shoudReturnFalseWithInt", test_satify_shoudReturnFalseWithInt),
        ("test_satify_shoudReturnTrueWithInt", test_satify_shoudReturnTrueWithInt),
        ("test_satify_shouldReturnFalseWithArray", test_satify_shouldReturnFalseWithArray),
        ("test_satify_shouldReturnFalseWithBool", test_satify_shouldReturnFalseWithBool),
        ("test_satify_shouldReturnFalseWithString", test_satify_shouldReturnFalseWithString),
        ("test_satify_shouldReturnTrueWithArray", test_satify_shouldReturnTrueWithArray),
        ("test_satify_shouldReturnTrueWithBool", test_satify_shouldReturnTrueWithBool),
        ("test_satify_shouldReturnTrueWithString", test_satify_shouldReturnTrueWithString),
        ("test_satisfy_shouldReturnFalseIfNotEquals", test_satisfy_shouldReturnFalseIfNotEquals),
        ("test_satisfy_shouldReturnTrueIfEquals", test_satisfy_shouldReturnTrueIfEquals),
    ]
}

extension FunctionBehaviourRegisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FunctionBehaviourRegisterTests = [
        ("test_recordedBehaviours_shouldReturnEmptyWhenNoMatchs", test_recordedBehaviours_shouldReturnEmptyWhenNoMatchs),
        ("test_recordedBehaviours_shouldReturnFunctionBehaviourMatched", test_recordedBehaviours_shouldReturnFunctionBehaviourMatched),
    ]
}

extension FunctionBehaviourTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__FunctionBehaviourTests = [
        ("test_handle_shouldCallHandlerWithCorrectParameters", test_handle_shouldCallHandlerWithCorrectParameters),
        ("test_handle_shouldReturnNilIfHandlerThrows", test_handle_shouldReturnNilIfHandlerThrows),
        ("test_handle_shouldReturnNilIfNotSameType", test_handle_shouldReturnNilIfNotSameType),
        ("test_handle_shouldReturnValueFormHandler", test_handle_shouldReturnValueFormHandler),
        ("test_handleThrowable_shouldCallHandlerWithCorrectParameters", test_handleThrowable_shouldCallHandlerWithCorrectParameters),
        ("test_handleThrowable_shouldReturnNilIfNotSameType", test_handleThrowable_shouldReturnNilIfNotSameType),
        ("test_handleThrowable_shouldReturnValueFormHandler", test_handleThrowable_shouldReturnValueFormHandler),
        ("test_handleThrowable_shouldThrowsIfHandlerThrows", test_handleThrowable_shouldThrowsIfHandlerThrows),
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
        ("test_callDescription_withGetProperty", test_callDescription_withGetProperty),
        ("test_callDescription_withGetSubscript", test_callDescription_withGetSubscript),
        ("test_callDescription_withNoParametersWhenFunction", test_callDescription_withNoParametersWhenFunction),
        ("test_callDescription_withParametersWhenFuntion", test_callDescription_withParametersWhenFuntion),
        ("test_callDescription_withSetProperty", test_callDescription_withSetProperty),
        ("test_callDescription_withSetSubscript", test_callDescription_withSetSubscript),
    ]
}

extension GivenStrategyTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__GivenStrategyTests = [
        ("test_resolve_shouldFailWithTooManyDefinedBehaviour", test_resolve_shouldFailWithTooManyDefinedBehaviour),
        ("test_resolve_shouldReturnFromNextStrategyWhenNoBehaviourFound", test_resolve_shouldReturnFromNextStrategyWhenNoBehaviourFound),
        ("test_resolve_shouldReturnFromNextStrategyWhenReturnTypeKO", test_resolve_shouldReturnFromNextStrategyWhenReturnTypeKO),
        ("test_resolve_shouldReturnValueFromBehaviour", test_resolve_shouldReturnValueFromBehaviour),
        ("test_resolveVoid_shouldFailWithNoDefinedBehaviour", test_resolveVoid_shouldFailWithNoDefinedBehaviour),
        ("test_resolveVoid_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO", test_resolveVoid_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO),
        ("test_resolveVoid_shouldFailWithTooManyDefinedBehaviour", test_resolveVoid_shouldFailWithTooManyDefinedBehaviour),
    ]
}

extension GivenStrategyThrowableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__GivenStrategyThrowableTests = [
        ("test_resolveThrowable_shouldFailWithTooManyDefinedBehaviour", test_resolveThrowable_shouldFailWithTooManyDefinedBehaviour),
        ("test_resolveThrowable_shouldReturnFromNextStrategyWhenNoBehaviourFound", test_resolveThrowable_shouldReturnFromNextStrategyWhenNoBehaviourFound),
        ("test_resolveThrowable_shouldReturnFromNextStrategyWhenReturnTypeKO", test_resolveThrowable_shouldReturnFromNextStrategyWhenReturnTypeKO),
        ("test_resolveThrowable_shouldReturnValueFromBehaviour", test_resolveThrowable_shouldReturnValueFromBehaviour),
        ("test_resolveThrowable_shouldThrowErroFromNextStrategy", test_resolveThrowable_shouldThrowErroFromNextStrategy),
        ("test_resolveThrowable_shouldThrowErrorFromBehaviour", test_resolveThrowable_shouldThrowErrorFromBehaviour),
        ("test_resolveVoidThrowable_shouldFailWithNoDefinedBehaviour", test_resolveVoidThrowable_shouldFailWithNoDefinedBehaviour),
        ("test_resolveVoidThrowable_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO", test_resolveVoidThrowable_shouldFailWithNoDefinedBehaviourWhenReturnTypeKO),
        ("test_resolveVoidThrowable_shouldFailWithTooManyDefinedBehaviour", test_resolveVoidThrowable_shouldFailWithTooManyDefinedBehaviour),
        ("test_resolveVoidThrowable_shouldThrowErroFromNextStrategy", test_resolveVoidThrowable_shouldThrowErroFromNextStrategy),
        ("test_resolveVoidThrowable_shouldThrowErrorFromBehaviour", test_resolveVoidThrowable_shouldThrowErrorFromBehaviour),
    ]
}

extension GlobalStubIntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__GlobalStubIntegrationTests = [
        ("test_function_shouldReturnStubCustom", test_function_shouldReturnStubCustom),
        ("test_functionBool_shouldReturnStubBool", test_functionBool_shouldReturnStubBool),
        ("test_functionInt_shouldReturnStubInt", test_functionInt_shouldReturnStubInt),
        ("test_functionString_shouldReturnStubString", test_functionString_shouldReturnStubString),
        ("test_functionVoid_shouldReturnVoid", test_functionVoid_shouldReturnVoid),
    ]
}

extension GlobalStubStrategyTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__GlobalStubStrategyTests = [
        ("test_resolve_shouldReturnFromNextStrategy", test_resolve_shouldReturnFromNextStrategy),
        ("test_resolve_shouldReturnStubCustom", test_resolve_shouldReturnStubCustom),
        ("test_resolveThrowable_shouldReturnFromNextStrategy", test_resolveThrowable_shouldReturnFromNextStrategy),
        ("test_resolveThrowable_shouldReturnStubCustom", test_resolveThrowable_shouldReturnStubCustom),
        ("test_resolveThrowable_shouldThrowErroFromNextStrategy", test_resolveThrowable_shouldThrowErroFromNextStrategy),
    ]
}

extension InternalErrorTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__InternalErrorTests = [
        ("test_description_withCast", test_description_withCast),
        ("test_description_withCastTwice", test_description_withCastTwice),
        ("test_description_withNoDefinedBehaviour", test_description_withNoDefinedBehaviour),
        ("test_description_withTooManyDefinedBehaviour", test_description_withTooManyDefinedBehaviour),
    ]
}

extension MockBehaviourRegisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockBehaviourRegisterTests = [
        ("test_record_shouldCallBehaviourRegister", test_record_shouldCallBehaviourRegister),
        ("test_recordedCall_shouldReturnFromBehaviourRegister", test_recordedCall_shouldReturnFromBehaviourRegister),
    ]
}

extension MockCallRegisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockCallRegisterTests = [
        ("test_recordCall_shouldCallRegister", test_recordCall_shouldCallRegister),
        ("test_recordedCall_shouldReturnFromCallRegister", test_recordedCall_shouldReturnFromCallRegister),
    ]
}

extension MockDefaultExtensionTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockDefaultExtensionTests = [
        ("test_stub_Bool", test_stub_Bool),
        ("test_stub_Int", test_stub_Int),
        ("test_stub_String", test_stub_String),
    ]
}

extension MockGivenIntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockGivenIntegrationTests = [
        ("test_computed_get_shouldReturnFromWillReturn", test_computed_get_shouldReturnFromWillReturn),
        ("test_function_shouldReturnDefaultValueIfNoMatch", test_function_shouldReturnDefaultValueIfNoMatch),
        ("test_function_shouldReturnValueFromWillCompletion", test_function_shouldReturnValueFromWillCompletion),
        ("test_function_shouldReturnValueFromWillReturnValue", test_function_shouldReturnValueFromWillReturnValue),
        ("test_function_shouldReturnValueFromWillReturnValues", test_function_shouldReturnValueFromWillReturnValues),
        ("test_function_shouldThrowErrorFromWillCompletion", test_function_shouldThrowErrorFromWillCompletion),
        ("test_function_shouldThrowFromWillThrowError", test_function_shouldThrowFromWillThrowError),
        ("test_function_shouldThrowFromWillThrowErrors", test_function_shouldThrowFromWillThrowErrors),
        ("test_given_shouldCallCompletionWithMockGiven", test_given_shouldCallCompletionWithMockGiven),
        ("test_identifier_get_shouldReturnFromWillReturn", test_identifier_get_shouldReturnFromWillReturn),
        ("test_identifier_set_shouldNotReturnFromWillCompletion", test_identifier_set_shouldNotReturnFromWillCompletion),
        ("test_identifier_set_shouldReturnFromWillCompletion", test_identifier_set_shouldReturnFromWillCompletion),
        ("test_subscriptFirstSecond_get_shouldReturnFromWillReturn", test_subscriptFirstSecond_get_shouldReturnFromWillReturn),
        ("test_subscriptXY_get_shouldReturnFromWillReturn", test_subscriptXY_get_shouldReturnFromWillReturn),
        ("test_subscriptXY_set_shouldNotReturnFromWillCompletion", test_subscriptXY_set_shouldNotReturnFromWillCompletion),
        ("test_subscriptXY_set_shouldReturnFromWillCompletion", test_subscriptXY_set_shouldReturnFromWillCompletion),
    ]
}

extension MockGivenTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockGivenTests = [
        ("test_given_shouldFailWithCast", test_given_shouldFailWithCast),
        ("test_given_shouldPass", test_given_shouldPass),
        ("test_givenCompletion_shouldPass", test_givenCompletion_shouldPass),
    ]
}

extension MockIntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockIntegrationTests = [
        ("test_computed_get_shouldReturnFromMockInitBlock", test_computed_get_shouldReturnFromMockInitBlock),
        ("test_function_shouldReturnValueFromMockInitBlock", test_function_shouldReturnValueFromMockInitBlock),
        ("test_functionStub_shouldReturnValueFromGlobalStub", test_functionStub_shouldReturnValueFromGlobalStub),
        ("test_functionStub_shouldReturnValueFromStub", test_functionStub_shouldReturnValueFromStub),
        ("test_subscript_shouldReturnValueFromMockInitBlock", test_subscript_shouldReturnValueFromMockInitBlock),
    ]
}

extension MockStrategyFactoryTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockStrategyFactoryTests = [
        ("test_create_shouldReturnCorrectStrategyChain", test_create_shouldReturnCorrectStrategyChain),
        ("test_create_shouldReturnCorrectStrategyChainWhenDefault", test_create_shouldReturnCorrectStrategyChainWhenDefault),
        ("test_create_shouldReturnUnresolvedStrategyWhenEmpty", test_create_shouldReturnUnresolvedStrategyWhenEmpty),
    ]
}

extension MockStubRegisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockStubRegisterTests = [
        ("test_recordedCall_shouldReturnFromBehaviourRegister", test_recordedCall_shouldReturnFromBehaviourRegister),
        ("test_recordedStub_shouldCallStubRegister", test_recordedStub_shouldCallStubRegister),
    ]
}

extension MockTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockTests = [
        ("test_mocked_shouldRecordCallIntoCallRegister", test_mocked_shouldRecordCallIntoCallRegister),
        ("test_mocked_shouldReturnValueFromStrategy", test_mocked_shouldReturnValueFromStrategy),
        ("test_mockedVoid_shouldCallStrategy", test_mockedVoid_shouldCallStrategy),
        ("test_mockedVoid_shouldRecordCallIntoCallRegister", test_mockedVoid_shouldRecordCallIntoCallRegister),
        ("test_wrappedValue_shouldFailWithCast", test_wrappedValue_shouldFailWithCast),
    ]
}

extension MockThenIntegrationTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockThenIntegrationTests = [
        ("test_callCount_whenParametersMatched", test_callCount_whenParametersMatched),
        ("test_function_shouldBeCalledWhenParametersMatched", test_function_shouldBeCalledWhenParametersMatched),
        ("test_Readable_get_shouldBeCalled", test_Readable_get_shouldBeCalled),
        ("test_receivedParameters_whenParametersMatched", test_receivedParameters_whenParametersMatched),
        ("test_subscriptFirstSecond_get_shouldBeCalled", test_subscriptFirstSecond_get_shouldBeCalled),
        ("test_subscriptXY_get_shouldBeCalled", test_subscriptXY_get_shouldBeCalled),
        ("test_subscriptXY_set_shouldBeCalledWhenParametersMatched", test_subscriptXY_set_shouldBeCalledWhenParametersMatched),
        ("test_subscriptXY_set_shouldNotBeCalledWhenParametersDontMatch", test_subscriptXY_set_shouldNotBeCalledWhenParametersDontMatch),
        ("test_then_shouldCallCompletionWithMockThen", test_then_shouldCallCompletionWithMockThen),
        ("test_Writable_get_shouldBeCalled", test_Writable_get_shouldBeCalled),
        ("test_Writable_set_shouldBeCalledWhenParametersMatched", test_Writable_set_shouldBeCalledWhenParametersMatched),
        ("test_Writable_set_shouldNotBeCalledWhenParametersDontMatch", test_Writable_set_shouldNotBeCalledWhenParametersDontMatch),
    ]
}

extension MockThenTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockThenTests = [
        ("test_then_shouldFailWithCast", test_then_shouldFailWithCast),
        ("test_then_shouldPass", test_then_shouldPass),
        ("test_thenCompletion_shouldPass", test_thenCompletion_shouldPass),
    ]
}

extension MockThrowableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockThrowableTests = [
        ("test_mockedThrowable_shouldRecordCallIntoCallRegister", test_mockedThrowable_shouldRecordCallIntoCallRegister),
        ("test_mockedThrowable_shouldReturnValueFromStrategy", test_mockedThrowable_shouldReturnValueFromStrategy),
        ("test_mockedThrowable_shouldThrowErrorFromBehaviour", test_mockedThrowable_shouldThrowErrorFromBehaviour),
        ("test_mockedThrowableVoid_shouldCallBehaviour", test_mockedThrowableVoid_shouldCallBehaviour),
        ("test_mockedThrowableVoid_shouldRecordCallIntoCallRegister", test_mockedThrowableVoid_shouldRecordCallIntoCallRegister),
        ("test_mockedThrowableVoid_shouldThrowErrorFromBehaviour", test_mockedThrowableVoid_shouldThrowErrorFromBehaviour),
    ]
}

extension MockablePropertyReadableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockablePropertyReadableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
    ]
}

extension MockablePropertyWritableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockablePropertyWritableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
        ("test_set_shouldCorrectlyCallBuilder", test_set_shouldCorrectlyCallBuilder),
        ("test_set_shouldReturnValueFromBuilder", test_set_shouldReturnValueFromBuilder),
    ]
}

extension MockableSubscriptReadableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockableSubscriptReadableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
    ]
}

extension MockableSubscriptWritableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__MockableSubscriptWritableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
        ("test_set_shouldCorrectlyCallBuilder", test_set_shouldCorrectlyCallBuilder),
        ("test_set_shouldReturnValueFromBuilder", test_set_shouldReturnValueFromBuilder),
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
        ("test_willReturn_withListShouldCorrectlyRegisterBahaviour", test_willReturn_withListShouldCorrectlyRegisterBahaviour),
        ("test_willThrow_shouldCorrectlyRegisterBahaviour", test_willThrow_shouldCorrectlyRegisterBahaviour),
    ]
}

extension PredicatBoolTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PredicatBoolTests = [
        ("test_isFalse_description", test_isFalse_description),
        ("test_isFalse_shouldReturnFalse", test_isFalse_shouldReturnFalse),
        ("test_isFalse_shouldReturnTrue", test_isFalse_shouldReturnTrue),
        ("test_isTrue_description", test_isTrue_description),
        ("test_isTrue_shouldReturnFalse", test_isTrue_shouldReturnFalse),
        ("test_isTrue_shouldReturnTrue", test_isTrue_shouldReturnTrue),
    ]
}

extension PredicateComparableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PredicateComparableTests = [
        ("test_equalsTo_description", test_equalsTo_description),
        ("test_equalsTo_shouldReturnFalseIfComparisonReturnFalse", test_equalsTo_shouldReturnFalseIfComparisonReturnFalse),
        ("test_equalsTo_shouldReturnTrueIfComparisonReturnTrue", test_equalsTo_shouldReturnTrueIfComparisonReturnTrue),
        ("test_lessThan_description", test_lessThan_description),
        ("test_lessThan_shouldReturnFalseIfComparisonReturnFalse", test_lessThan_shouldReturnFalseIfComparisonReturnFalse),
        ("test_lessThan_shouldReturnTrueIfComparisonReturnTrue", test_lessThan_shouldReturnTrueIfComparisonReturnTrue),
        ("test_lessThanOrEqualsTo_description", test_lessThanOrEqualsTo_description),
        ("test_lessThanOrEqualsTo_shouldReturnFalseIfComparisonReturnFalse", test_lessThanOrEqualsTo_shouldReturnFalseIfComparisonReturnFalse),
        ("test_lessThanOrEqualsTo_shouldReturnTrueIfComparisonReturnTrue", test_lessThanOrEqualsTo_shouldReturnTrueIfComparisonReturnTrue),
        ("test_moreThan_description", test_moreThan_description),
        ("test_moreThan_shouldReturnFalseIfComparisonReturnFalse", test_moreThan_shouldReturnFalseIfComparisonReturnFalse),
        ("test_moreThan_shouldReturnTrueIfComparisonReturnTrue", test_moreThan_shouldReturnTrueIfComparisonReturnTrue),
        ("test_moreThanOrEqualsTo_description", test_moreThanOrEqualsTo_description),
        ("test_moreThanOrEqualsTo_shouldReturnFalseIfComparisonReturnFalse", test_moreThanOrEqualsTo_shouldReturnFalseIfComparisonReturnFalse),
        ("test_moreThanOrEqualsTo_shouldReturnTrueIfComparisonReturnTrue", test_moreThanOrEqualsTo_shouldReturnTrueIfComparisonReturnTrue),
    ]
}

extension PredicateOptionalTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PredicateOptionalTests = [
        ("test_isNil_description", test_isNil_description),
        ("test_isNil_shouldReturnFalse", test_isNil_shouldReturnFalse),
        ("test_isNil_shouldReturnTrue", test_isNil_shouldReturnTrue),
    ]
}

extension PredicateTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__PredicateTests = [
        ("test_any_description", test_any_description),
        ("test_any_shouldReturnFalse", test_any_shouldReturnFalse),
        ("test_any_shouldReturnTrue", test_any_shouldReturnTrue),
        ("test_match_description", test_match_description),
        ("test_match_KeyPathDescription", test_match_KeyPathDescription),
        ("test_match_shouldReturnFalseIfInputNotMatched", test_match_shouldReturnFalseIfInputNotMatched),
        ("test_match_shouldReturnFalseIfInputNotMatchedByAnyPredicate", test_match_shouldReturnFalseIfInputNotMatchedByAnyPredicate),
        ("test_match_shouldReturnFalseIfInputNotSameReference", test_match_shouldReturnFalseIfInputNotSameReference),
        ("test_match_shouldReturnFalseIfKeyPathReturnFalse", test_match_shouldReturnFalseIfKeyPathReturnFalse),
        ("test_match_shouldReturnTrueIfInputMatched", test_match_shouldReturnTrueIfInputMatched),
        ("test_match_shouldReturnTrueIfInputMatchedByAnyPredicate", test_match_shouldReturnTrueIfInputMatchedByAnyPredicate),
        ("test_match_shouldReturnTrueIfInputSameReference", test_match_shouldReturnTrueIfInputSameReference),
        ("test_match_shouldReturnTrueIfKeyPathReturnTrue", test_match_shouldReturnTrueIfKeyPathReturnTrue),
        ("test_match_withMatchShouldReturnFalseIfInputIsNotTheSameType", test_match_withMatchShouldReturnFalseIfInputIsNotTheSameType),
        ("test_not_description", test_not_description),
        ("test_not_shouldReturnFalse", test_not_shouldReturnFalse),
        ("test_not_shouldReturnTrue", test_not_shouldReturnTrue),
    ]
}

extension StubStrategyTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StubStrategyTests = [
        ("test_resolve_shouldReturnFromNextStrategyWhenNoStubFound", test_resolve_shouldReturnFromNextStrategyWhenNoStubFound),
        ("test_resolve_shouldReturnValueFromRegister", test_resolve_shouldReturnValueFromRegister),
        ("test_resolveThrowable_shouldReturnFromNextStrategyWhenNoStubFound", test_resolveThrowable_shouldReturnFromNextStrategyWhenNoStubFound),
        ("test_resolveThrowable_shouldReturnValueFromRegister", test_resolveThrowable_shouldReturnValueFromRegister),
        ("test_resolveThrowable_shouldThrowErroFromNextStrategy", test_resolveThrowable_shouldThrowErroFromNextStrategy),
    ]
}

extension StubTypeRegisterTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__StubTypeRegisterTests = [
        ("test_recordedStub_shouldReturnNilWhenValueNotRecordedBefore", test_recordedStub_shouldReturnNilWhenValueNotRecordedBefore),
        ("test_recordedStub_shouldReturnValueWhenValueRecordedBefore", test_recordedStub_shouldReturnValueWhenValueRecordedBefore),
    ]
}

extension UnresolvedStrategyTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__UnresolvedStrategyTests = [
        ("test_resolve_shouldReturnFromErrorHandler", test_resolve_shouldReturnFromErrorHandler),
        ("test_resolveThrowable_shouldReturnFromErrorHandler", test_resolveThrowable_shouldReturnFromErrorHandler),
    ]
}

extension VerifiablePropertyReadableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VerifiablePropertyReadableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
    ]
}

extension VerifiablePropertyWritableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VerifiablePropertyWritableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
        ("test_set_shouldCorrectlyCallBuilder", test_set_shouldCorrectlyCallBuilder),
        ("test_set_shouldReturnValueFromBuilder", test_set_shouldReturnValueFromBuilder),
    ]
}

extension VerifiableSubcriptWritableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VerifiableSubcriptWritableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
        ("test_set_shouldCorrectlyCallBuilder", test_set_shouldCorrectlyCallBuilder),
        ("test_set_shouldReturnValueFromBuilder", test_set_shouldReturnValueFromBuilder),
    ]
}

extension VerifiableSubscriptReadableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VerifiableSubscriptReadableTests = [
        ("test_get_shouldCorrectlyCallBuilder", test_get_shouldCorrectlyCallBuilder),
        ("test_get_shouldReturnValueFromBuilder", test_get_shouldReturnValueFromBuilder),
    ]
}

extension VerifiableTests {
    // DO NOT MODIFY: This is autogenerated, use:
    //   `swift test --generate-linuxmain`
    // to regenerate.
    static let __allTests__VerifiableTests = [
        ("test_callCount_shouldReturnNumberOfMatchedFunctionCallFromCallRegister", test_callCount_shouldReturnNumberOfMatchedFunctionCallFromCallRegister),
        ("test_callCount_shouldReturnZeroWhenNoFunctionCallFromCallRegisterMatched", test_callCount_shouldReturnZeroWhenNoFunctionCallFromCallRegisterMatched),
        ("test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatched", test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatched),
        ("test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimes", test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimes),
        ("test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimesExactly", test_called_shouldNotRecordFailureWhenFunctionCallFromCallRegisterMatchedTimesExactly),
        ("test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatched", test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatched),
        ("test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimes", test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimes),
        ("test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimesExactly", test_called_shouldRecordFailureWhenNoFunctionCallFromCallRegisterMatchedTimesExactly),
        ("test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType", test_disambiguate_shouldReturnSameVerifiableWithDisambiguatedReturnType),
        ("test_receivedParameters_shouldReturnAllCallsParametersWhenFunctionCallFromCallRegisterMatched", test_receivedParameters_shouldReturnAllCallsParametersWhenFunctionCallFromCallRegisterMatched),
        ("test_receivedParameters_shouldReturnEmptyWhenNoFunctionCallFromCallRegisterMatched", test_receivedParameters_shouldReturnEmptyWhenNoFunctionCallFromCallRegisterMatched),
    ]
}

public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(AnyPredicateEquatableTests.__allTests__AnyPredicateEquatableTests),
        testCase(FunctionBehaviourRegisterTests.__allTests__FunctionBehaviourRegisterTests),
        testCase(FunctionBehaviourTests.__allTests__FunctionBehaviourTests),
        testCase(FunctionCallRegisterTests.__allTests__FunctionCallRegisterTests),
        testCase(FunctionIdentifierTests.__allTests__FunctionIdentifierTests),
        testCase(GivenStrategyTests.__allTests__GivenStrategyTests),
        testCase(GivenStrategyThrowableTests.__allTests__GivenStrategyThrowableTests),
        testCase(GlobalStubIntegrationTests.__allTests__GlobalStubIntegrationTests),
        testCase(GlobalStubStrategyTests.__allTests__GlobalStubStrategyTests),
        testCase(InternalErrorTests.__allTests__InternalErrorTests),
        testCase(MockBehaviourRegisterTests.__allTests__MockBehaviourRegisterTests),
        testCase(MockCallRegisterTests.__allTests__MockCallRegisterTests),
        testCase(MockDefaultExtensionTests.__allTests__MockDefaultExtensionTests),
        testCase(MockGivenIntegrationTests.__allTests__MockGivenIntegrationTests),
        testCase(MockGivenTests.__allTests__MockGivenTests),
        testCase(MockIntegrationTests.__allTests__MockIntegrationTests),
        testCase(MockStrategyFactoryTests.__allTests__MockStrategyFactoryTests),
        testCase(MockStubRegisterTests.__allTests__MockStubRegisterTests),
        testCase(MockTests.__allTests__MockTests),
        testCase(MockThenIntegrationTests.__allTests__MockThenIntegrationTests),
        testCase(MockThenTests.__allTests__MockThenTests),
        testCase(MockThrowableTests.__allTests__MockThrowableTests),
        testCase(MockablePropertyReadableTests.__allTests__MockablePropertyReadableTests),
        testCase(MockablePropertyWritableTests.__allTests__MockablePropertyWritableTests),
        testCase(MockableSubscriptReadableTests.__allTests__MockableSubscriptReadableTests),
        testCase(MockableSubscriptWritableTests.__allTests__MockableSubscriptWritableTests),
        testCase(MockableTests.__allTests__MockableTests),
        testCase(PredicatBoolTests.__allTests__PredicatBoolTests),
        testCase(PredicateComparableTests.__allTests__PredicateComparableTests),
        testCase(PredicateOptionalTests.__allTests__PredicateOptionalTests),
        testCase(PredicateTests.__allTests__PredicateTests),
        testCase(StubStrategyTests.__allTests__StubStrategyTests),
        testCase(StubTypeRegisterTests.__allTests__StubTypeRegisterTests),
        testCase(UnresolvedStrategyTests.__allTests__UnresolvedStrategyTests),
        testCase(VerifiablePropertyReadableTests.__allTests__VerifiablePropertyReadableTests),
        testCase(VerifiablePropertyWritableTests.__allTests__VerifiablePropertyWritableTests),
        testCase(VerifiableSubcriptWritableTests.__allTests__VerifiableSubcriptWritableTests),
        testCase(VerifiableSubscriptReadableTests.__allTests__VerifiableSubscriptReadableTests),
        testCase(VerifiableTests.__allTests__VerifiableTests),
    ]
}
#endif
