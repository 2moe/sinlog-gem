# Usage:
#
# test_task:
#   rake test
#
# gem_tasks:
#   rake install
#   rake release
#

require 'bundler/gem_tasks'
require 'minitest/test_task'

# task :test
Minitest::TestTask.create

# default: :test
task default: %i[test]
