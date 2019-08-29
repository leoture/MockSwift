#!/bin/bash

swift test --generate-linuxmain
swift test
docker-compose up
