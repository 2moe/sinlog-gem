# frozen_string_literal: true

class Sinlog
  # LogShortExt is a Refinement that adds convenient logging methods to all objects.
  #
  # Similar to LogExt, but methods omit the `log_` prefix.
  #
  # For example:
  #   * `"msg".err` instead of `"msg".log_err`;
  #   * `"msg".warn` instead of `"msg".log_warn`
  #
  # When activated with `using Sinlog::LogShortExt`, any object can call:
  #
  # == Overview
  #
  # * `dbg`   – Logs the object at DEBUG level
  # * `info`  – Logs the object at INFO level
  # * `warn`  – Logs the object at WARN level
  # * `err`   – Logs the object at ERROR level
  # * `fatal` – Logs the object at FATAL level
  # * `unk`   – Logs the object at UNKNOWN level
  #
  # == Example
  #
  #     require 'sinlog'
  #
  #     class A
  #       using Sinlog::LogShortExt
  #
  #       def demo
  #         "Something happened".warn
  #       end
  #     end
  #
  module LogShortExt
    # Logs the current object at *debug* level using Sinlog.logger
    refine Object do
      def dbg
        Sinlog.logger.debug(self)
      end
    end

    # Logs the current object at *information* level using Sinlog.logger
    refine Object do
      # logger.info
      def info
        Sinlog.logger.info(self)
      end
    end

    # Logs the current object at *warning* level using Sinlog.logger
    refine Object do
      def warn
        Sinlog.logger.warn(self)
      end
    end

    # Logs the current object at *error* level using Sinlog.logger
    refine Object do
      def err
        Sinlog.logger.error(self)
      end
    end

    # Logs the current object at *fatal* level using Sinlog.logger
    refine Object do
      def fatal
        Sinlog.logger.fatal(self)
      end
    end

    # Logs the current object at *unknown* level using Sinlog.logger
    refine Object do
      def unk
        Sinlog.logger.unknown(self)
      end
    end

    # -----
  end
end
