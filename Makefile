WORKSPACE = MockSwift.xcworkspace
DESTINATION = 'platform=iOS Simulator,name=iPhone 11'
XCBUILD = xcodebuild
XCFLAGS = -workspace $(WORKSPACE)
XCPRETTY = xcpretty && exit $${PIPESTATUS[0]}
SPM = swift

SOURCERY_VERSION := $(shell sourcery --version 2>/dev/null)

.DEFAULT_GOAL = all

all: spm-tests MockSwift-Package MockSwiftExample linux-tests

tools:
	@echo "\x1b[0;34m"
	@echo "=================="
	@echo "== Tools update =="
	@echo "=================="
	@echo "\x1b[0;0m"
	bundle update

spm-tests:
	@echo "\x1b[0;34m"
	@echo "================================="
	@echo "== Swift Package Manager Tests =="
	@echo "================================="
	@echo "\x1b[0;0m"
	${SPM} test 2>&1 | ${XCPRETTY}

MockSwift-Package:
	@echo "\x1b[0;34m"
	@echo "============================="
	@echo "== MockSwift-Package Tests =="
	@echo "============================="
	@echo "\x1b[0;0m"
	${XCBUILD} ${XCFLAGS} -scheme $@ test | ${XCPRETTY}

sourcery:
ifndef SOURCERY_VERSION
	brew install sourcery
endif

MockSwiftExample: sourcery
	@echo "\x1b[0;34m"
	@echo "============================"
	@echo "== MockSwiftExample Tests =="
	@echo "============================"
	@echo "\x1b[0;0m"
	${XCBUILD} ${XCFLAGS} -scheme $@ -destination $(DESTINATION) test | ${XCPRETTY}

generate-linuxmain:
	@echo "\x1b[0;34m"
	@echo "==============================="
	@echo "== Generate Linux Main Tests =="
	@echo "==============================="
	@echo "\x1b[0;0m"
	${SPM} test --generate-linuxmain

linux-tests: generate-linuxmain
	@echo "\x1b[0;34m"
	@echo "================="
	@echo "== Linux Tests =="
	@echo "================="
	@echo "\x1b[0;0m"
	docker-compose up

linux-ci: tools spm-tests

macOS-ci: tools spm-tests MockSwift-Package MockSwiftExample

.PHONY: MockSwift-Package MockSwiftExample
