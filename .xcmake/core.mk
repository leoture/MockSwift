XCMAKE_PATH := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
XCMAKE_BIN_PATH := $(XCMAKE_PATH)bin
XCMAKE_SRC_PATH := $(XCMAKE_PATH)src
PATH := $(XCMAKE_BIN_PATH):$(PATH)

XCMAKE_PLUGINS :=  $(wildcard $(XCMAKE_SRC_PATH)/*.swift)
XCMAKE_PLUGINS_BIN := $(patsubst $(XCMAKE_SRC_PATH)/%.swift, $(XCMAKE_BIN_PATH)/%, $(XCMAKE_PLUGINS))

$(XCMAKE_PLUGINS_BIN): $(XCMAKE_BIN_PATH)/% : $(XCMAKE_SRC_PATH)/%.swift
	@mkdir -p $(XCMAKE_BIN_PATH)
	@swiftc $^ -o $@

xcmake: $(XCMAKE_PLUGINS_BIN)
