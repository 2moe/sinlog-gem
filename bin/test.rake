#!/usr/bin/env -S rake -f
# frozen_string_literal: true

# Usage:
#
#  gem install rake minitest
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
