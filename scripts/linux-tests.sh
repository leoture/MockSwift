#!/bin/bash
swift package update &&
swift test --generate-linuxmain &&
swift test
