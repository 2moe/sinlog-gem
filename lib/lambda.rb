# frozen_string_literal: true

# rubocop:disable Lint/MissingCopEnableDirective, Style/ClassVars

class Sinlog
  # Module to simplify logger calls using lambda expressions.
  #
  # The following methods define lambda expressions for different log levels.
  # These lambdas can be used to log messages at the corresponding log level.
  module LogLambdaExt
    @@_sinlog_lambda_ext_logger_ = Sinlog.instance.logger

    # Debug Logging
    #
    # Example:
    #
    #   require 'sinlog'
    #   include Sinlog::LogLambdaExt
    #
    #   'Debug Message'.then(&log_dbg)
    #
    #   cmd = %w[ls -l -h]
    #   "cmd_arr: #{cmd}".tap(&log_dbg)
    def log_dbg
      ->(msg) { @@_sinlog_lambda_ext_logger_.debug(msg) }
    end

    # Info(a.k.a. Information) Logging
    #
    # Example:
    #
    #   require 'pathname'
    #
    #   Pathname('lib/lambda.rb').tap {
    #       "Filename: #{it}".then(&log_info)
    #       "size: #{it.size}".then(&log_info)
    #   }
    def log_info
      ->(msg) { @@_sinlog_lambda_ext_logger_.info(msg) }
    end

    # Warning Logging
    #
    # Example:
    #
    #   arr = (0..256).to_a
    #   'This array is too large'.then(&log_warn) if arr.length > 128
    def log_warn
      ->(msg) { @@_sinlog_lambda_ext_logger_.warn(msg) }
    end

    # Warning Logging
    #
    # Same as `log_warn`
    def log_warning
      ->(msg) { @@_sinlog_lambda_ext_logger_.warn(msg) }
    end

    # Warning Logging
    #
    # Same as `log_warn`
    def log_wng
      ->(msg) { @@_sinlog_lambda_ext_logger_.warn(msg) }
    end

    # Error Logging
    #
    # Example:
    #
    #   'CLI error: You should pass the --url'.then(&log_err)
    def log_err
      ->(msg) { @@_sinlog_lambda_ext_logger_.error(msg) }
    end

    # Fatal error logging
    #
    # Example:
    #
    #   'Failed to open xxx'.then(&log_fatal)
    def log_fatal
      ->(msg) { @@_sinlog_lambda_ext_logger_.fatal(msg) }
    end

    # Example:
    #
    #   'Unknown'.then(&log_unk)
    def log_unk
      ->(msg) { @@_sinlog_lambda_ext_logger_.unknown(msg) }
    end
  end

  # Similar to LogLambdaExt, but the methods do not have the `log_` prefix.
  # One important thing to note is that LambdaExt defines the `warning` method, not `warn`.
  #
  # The following methods define lambda expressions for different log levels.
  # These lambdas can be used to log messages at the corresponding log level.
  module LambdaExt
    @@_sinlog_lambda_ext_logger_ = Sinlog.instance.logger

    # Debug Logging
    #
    # Example:
    #
    #   require 'sinlog'
    #   include Sinlog::LambdaExt
    #
    #   'Debug Message'.then(&dbg)
    #
    #   cmd = %w[ls -l -h]
    #   "cmd_arr: #{cmd}".tap(&dbg)
    def dbg
      ->(msg) { @@_sinlog_lambda_ext_logger_.debug(msg) }
    end

    # Info(a.k.a. Information) Logging
    #
    # Example:
    #
    #   require 'pathname'
    #
    #   Pathname('lib/lambda.rb').tap {
    #       "Filename: #{it}".then(&info)
    #       "size: #{it.size}".then(&info)
    #   }
    def info
      ->(msg) { @@_sinlog_lambda_ext_logger_.info(msg) }
    end

    # Warning Logging
    #
    # Example:
    #
    #   arr = (0..1024).to_a
    #   'This array is too large'.then(&warning) if arr.length > 128
    def warning
      ->(msg) { @@_sinlog_lambda_ext_logger_.warn(msg) }
    end

    # Warning Logging
    #
    # Same as `warning`
    def wng
      ->(msg) { @@_sinlog_lambda_ext_logger_.warn(msg) }
    end

    # Error Logging
    #
    # Example:
    #
    #   'CLI error: You should pass the --url'.then(&err)
    def err
      ->(msg) { @@_sinlog_lambda_ext_logger_.error(msg) }
    end

    # Fatal error logging
    #
    # Example:
    #
    #   'Failed to open xxx'.then(&fatal)
    def fatal
      ->(msg) { @@_sinlog_lambda_ext_logger_.fatal(msg) }
    end

    # Unknown(log-level) logging
    #
    # Example:
    #
    #   'Unknown'.then(&unk)
    def unk
      ->(msg) { @@_sinlog_lambda_ext_logger_.unknown(msg) }
    end
  end

  # Defines the `warn` lambda expression
  module LambdaWarnExt
    @@_sinlog_lambda_ext_logger_ = Sinlog.instance.logger
    # Warning Logging
    #
    # Same as `LambdaExt.warning`
    def warn
      ->(msg) { @@_sinlog_lambda_ext_logger_.warn(msg) }
    end
  end
end
