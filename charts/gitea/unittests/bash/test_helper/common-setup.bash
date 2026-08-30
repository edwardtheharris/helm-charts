#!/usr/bin/env bash

function common_setup() {
  load "$TEST_ROOT/test_helper/bats-support/load"
  load "$TEST_ROOT/test_helper/bats-assert/load"
  load "$TEST_ROOT/test_helper/bats-mock/stub"
}
