include .xcmake/core.mk

WORKSPACE = MockSwift.xcworkspace
DESTINATION = 'platform=iOS Simulator,name=iPhone 11'
XCBUILD = xcodebuild
XCFLAGS = -workspace $(WORKSPACE)

XCPRETTY =  xcpretty && exit $${PIPESTATUS[0]}

SPM = swift

SOURCERY_VERSION := $(shell sourcery --version 2>/dev/null)

.DEFAULT_GOAL = all
all: spm-tests MockSwift-Package MockSwiftExample linux-tests

tools: xcmake
	@description "Tools update"
	bundle update

documentation: tools
	@description "Generate documentation"
	jazzy

spm-tests: xcmake
	@description "Swift Package Manager Tests"
	${SPM} test

MockSwift-Package: xcmake
	@description "MockSwift-Package Tests"
	${XCBUILD} ${XCFLAGS} -scheme $@ test | ${XCPRETTY}

sourcery:
ifndef SOURCERY_VERSION
	brew install sourcery
endif

MockSwiftExample: xcmake sourcery
	@description "MockSwiftExample Tests"
	${XCBUILD} ${XCFLAGS} -scheme $@ -destination $(DESTINATION) test | ${XCPRETTY}

generate-linuxmain: xcmake
	@description "Generate Linux Main Tests"
	${SPM} test --generate-linuxmain

linux-tests: xcmake generate-linuxmain
	@description "Linux Tests"
	docker-compose up

linux-ci: spm-tests

macOS-ci: tools spm-tests MockSwift-Package MockSwiftExample

.PHONY: MockSwift-Package MockSwiftExample xcmake
