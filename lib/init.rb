# frozen_string_literal: true

# Logger Singleton Class
class Sinlog
  include Singleton
  attr_reader :logger

  # Define colors for different log levels
  COLORS = {
    debug: "\e[34m",   # Blue
    info: "\e[36m",    # Cyan
    warn: "\e[33m",    # Yellow
    error: "\e[31m",   # Red
    fatal: "\e[35m",   # Magenta
    unknown: "\e[0m"   # Reset
  }.freeze

  # log levels
  LV = {
    debug: Logger::DEBUG,
    info: Logger::INFO,
    warn: Logger::WARN,
    error: Logger::ERROR,
    fatal: Logger::FATAL,
    unknown: Logger::UNKNOWN
  }.freeze

  # Example:
  #
  #   logger = Sinlog.instance.logger
  #   logger.info "Information"
  #   logger.debug "This is a debug message"
  #
  # The log output format will be similar to:
  #
  #   [INFO] 21:29:22.004  Information
  #   [DEBUG] 21:29:22.005  This is a debug message
  #
  # Where "INFO" is highlighted in cyan and "DEBUG" is highlighted in blue.
  #
  # The default log level is set based on the RUBY_LOG environment variable.
  # If this variable is not set, the default level is DEBUG.
  def initialize
    @logger = Logger.new($stderr)
    fetch_env_and_update_log_level
    @logger.formatter = proc do |severity, datetime, progname, msg|
      color = COLORS[severity.downcase.to_sym]
      reset = COLORS[:unknown]
      formatted_datetime = datetime.strftime('%H:%M:%S.%L')
      prog = format_prog_name(progname)
      "[#{color}#{severity}#{reset}] #{formatted_datetime} #{prog}#{msg}\n"
    end
  end

  # Set the `@logger.level` (**log level**) based on the value of an environment variable.
  #
  # If env_name is not specified, it reads the value of the `RUBY_LOG` environment variable.
  #
  # - If the value exists, it is converted to lowercase, then to a symbol, and looked up in the LV hash;
  # - If it does not exist, the default level is DEBUG;
  # - If the lookup result is invalid, the level is set to UNKNOWN;
  # - If the environment variable value is empty, the lookup result will be invalid,
  #   and the level will be set to UNKNOWN.
  #
  # Example:
  #
  #   ENV["XX_LOG"] = "info" # or setenv in posix-sh: export XX_LOG=info
  #
  #   logger = Sinlog.instance.tap { it.fetch_env_and_update_log_level("XX_LOG") }.logger
  #
  #   logger.debug "This message will not be displayed because the current log level is info"
  #   logger.info "Hello!"
  def fetch_env_and_update_log_level(env_name = 'RUBY_LOG')
    env_lv = ENV[env_name]&.downcase&.to_sym || :debug

    (LV[env_lv] || Logger::UNKNOWN)
      .then { @logger.level = _1 }
  end

  private

  def format_prog_name(progname)
    return '' if progname.to_s.empty?

    green = "\e[32m"
    reset = "\e[0m"
    space = ' '
    "<#{green}#{progname}#{reset}>#{space}"
  end
end
