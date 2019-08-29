#!/bin/bash
previousCount=$(wc -m Tests/MockSwiftTests/XCTestManifests.swift | awk '{print $1}')
swift test --generate-linuxmain
currentCount=$(wc -m Tests/MockSwiftTests/XCTestManifests.swift | awk '{print $1}')
if [ $previousCount != $currentCount ]; then
  exit 1
fi
