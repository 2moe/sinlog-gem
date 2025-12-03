#!/usr/bin/env rake
# frozen_string_literal: true

# Usage:
#
# - show all tasks:
#     ./test.rake --tasks
#
# - run test task:
#     ./test.rake test

require_relative 'cd_parent_dir'

# require 'bundler/gem_tasks'
require 'minitest/test_task'

# task :test
Minitest::TestTask.create

# default: :test
task default: %i[test]
