# frozen_string_literal: true

# Usage:
#
#   require 'sinlog'
#
#   logger = Sinlog.instance.logger
#   logger.info "Information"
#   logger.debug "This is a debug message"
#
# Read more: https://github.com/2moe/sinlog-gem

require_relative 'sinlog/version'
require 'singleton'
require 'logger'

require_relative 'init'
require_relative 'lambda'
