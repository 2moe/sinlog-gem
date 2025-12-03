# frozen_string_literal: true

require_relative 'helper/test_helper'

def display_msgs
  log = Sinlog.logger
  log.debug 'debug'
  log.info 'information'
  log.warn 'warning'
  log.error 'error'
  log.fatal 'fatal'
  log.unknown 'unknown'
end

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

  def test_info_lv
    Sinlog.logger(level: :info)
    display_msgs
  end

  def test_info_lv_from_env
    ENV['XX_LOG'] = 'info'
    Sinlog.logger(env_name: 'XX_LOG')
    display_msgs
  end

  def test_warn_lv
    Sinlog.logger(level: 'warning')
    display_msgs
  end

  def test_warn_lv_from_env
    ENV['XX_LOG'] = 'warn'
    Sinlog.logger(env_name: 'XX_LOG')
    display_msgs
  end

  def test_invalid_lv
    Sinlog.logger(level: '⚠️')
    display_msgs
  end

  def test_invalid_lv_from_env
    ENV['XX_LOG'] = '⚠️'
    Sinlog.logger(env_name: 'XX_LOG')
    display_msgs
  end
end

# ---------------------------
class TestShortRF < Minitest::Test
  using Sinlog::ShortRefin

  def test_info_message
    'Hello'.info
  end
end

class TestRF < Minitest::Test
  using Sinlog::Refin

  def test_info_message
    'Hello'.log_info
  end
end

# ---------------------------
class TestMixin < Minitest::Test
  include Sinlog::Mixin

  def test_info_message
    'Hello wonderful world 🌍'.log_info
  end
end

class TestShortMixin < Minitest::Test
  include Sinlog::ShortMixin

  def test_warn_message
    '🌍'.warn
    # Kernel.warn '🌍'
  end
end
