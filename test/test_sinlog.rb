# frozen_string_literal: true

require 'test_helper'

class TestSinlog < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Sinlog::VERSION
  end
  # def test_it_does_something_useful
  #   assert true
  # end

  def test_show_debug_msg
    Sinlog.instance.logger.debug 'This is a debug message'
    Kernel.include Sinlog::LogLambdaExt
    'msg2'.tap(&log_dbg)
  end
end
