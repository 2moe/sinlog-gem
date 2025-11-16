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
    Sinlog.logger.debug 'This is a debug message'
  end
end

class TestRF < Minitest::Test
  using Sinlog::LogShortExt

  def test_info_message
    'Hello'.info
  end
end
