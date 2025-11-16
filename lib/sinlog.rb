# frozen_string_literal: true

# == Logging Modules Overview
#
# The following modules provide different ways to add logging capabilities:
#
# * Loggable      : A mixin module. Include it in your class to add logging methods with the `log_` prefix.
# * LogExt        : A refinement. Activate it with `using` to add logging methods with the `log_` prefix.
# * LogShortExt   : A refinement. Similar to LogExt, but methods omit the `log_` prefix.
#
# === Comparison Table
#
#  Module         | Type        | Activation    | Method Naming
#  -------------- | ----------  | ------------  | -------------------------
#  Loggable       | Mixin       | include       | log_dbg, log_info, etc.
#  LogExt         | Refinement  | using         | log_dbg, log_info, etc.
#  LogShortExt    | Refinement  | using         | dbg, info, warn, err, fatal, unk
#
# == Examples
#
# === Classic (neither mixin nor refinement)
#
#     require 'sinlog'
#
#     log = Sinlog.logger
#     log.info "Information"
#     log.debug "This is a debug message"
#
# === Mixin
#
#     require 'sinlog'
#     include Sinlog::Loggable
#     "Hello".log_info
#
# === Refinement
#
#     require 'sinlog'
#     using Sinlog::LogShortExt
#     "Hello".info
#
# Read more: https://github.com/2moe/sinlog-gem
class Sinlog; end

require_relative 'sinlog/version'

require_relative 'sinlog/init'
require_relative 'sinlog/loggable'
require_relative 'sinlog/log_ext'
require_relative 'sinlog/log_short_ext'
