# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.

TESTS_DIR = ../..

# see explanations in cpp/pulse/Makefile for the custom isystem
CLANG_OPTIONS = -x c++ -std=c++17 -nostdinc++ -isystem$(CLANG_INCLUDES)/c++/v1/ -c
INFER_OPTIONS = \
  --pulse-only --debug-exceptions --no-pulse-force-continue --pulse-taint-config .infertaintconfig \
  --project-root $(TESTS_DIR) --procs-to-analyze-index procs-to-analyze.txt

# test that the error messages are good; sort of mimicks what gets displayed on the console
INFERPRINT_OPTIONS = --issues-tests-fields file,procedure,line,column,severity,bug_type,qualifier,suggestion --issues-tests

SOURCES = $(wildcard *.cpp)

include $(TESTS_DIR)/clang.make

infer-out/report.json: $(MAKEFILE_LIST)
