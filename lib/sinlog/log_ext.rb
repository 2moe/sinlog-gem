# frozen_string_literal: true

class Sinlog
  # LogExt is a Refinement that adds convenient logging methods to all objects.
  #
  # When activated with `using Sinlog::LogExt`, any object can call:
  #
  # == Overview
  #
  # * `log_dbg`   – Logs the object at DEBUG level
  # * `log_info`  – Logs the object at INFO level
  # * `log_warn`  – Logs the object at WARN level
  # * `log_err`   – Logs the object at ERROR level
  # * `log_fatal` – Logs the object at FATAL level
  # * `log_unk`   – Logs the object at UNKNOWN level
  #
  # == Example
  #
  #     require 'sinlog'
  #
  #     class A
  #       using Sinlog::LogExt
  #       def demo
  #         "Something happened".log_warn
  #       end
  #     end
  #
  module LogExt
    refine Object do
      # Logs the current object at *debug* level using Sinlog.logger
      def log_dbg
        Sinlog.logger.debug(self)
      end

      # Logs the current object at *information* level using Sinlog.logger
      def log_info
        Sinlog.logger.info(self)
      end

      # Logs the current object at *warning* level using Sinlog.logger
      def log_warn
        Sinlog.logger.warn(self)
      end

      # Logs the current object at *error* level using Sinlog.logger
      def log_err
        Sinlog.logger.error(self)
      end

      # Logs the current object at *fatal* level using Sinlog.logger
      def log_fatal
        Sinlog.logger.fatal(self)
      end

      # Logs the current object at *unknown* level using Sinlog.logger
      def log_unk
        Sinlog.logger.unknown(self)
      end
      # -----
    end
  end
end
