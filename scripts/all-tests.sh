#!/bin/bash

swift test --generate-linuxmain
swift test
docker-compose up
xcodebuild -scheme MockSwiftExample -workspace MockSwift.xcworkspace -destination "name=iPhone 11" test
