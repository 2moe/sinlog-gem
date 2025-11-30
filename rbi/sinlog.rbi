# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/Documentation
# typed: true

module Sinlog
  class Logger
    include ::Singleton::SingletonInstanceMethods
    include ::Singleton
    extend ::Singleton::SingletonClassMethods

    sig { params(level: T.nilable(Integer)).returns(::Logger) }
    def self.logger_with_level(level = LV[:warn]); end

    sig { returns(::Logger) }
    def self.logger; end

    sig { returns(::Logger) }
    def logger; end

    sig { params(env_name: String).returns(NilClass) }
    def set_level_from_env!(env_name = ''); end

    private

    sig { params(progname: T.any(String, Symbol)).returns(String) }
    def format_prog_name(progname); end
  end
end

Sinlog::COLORS = T.let(T.unsafe(nil), T::Hash[Symbol, String])
Sinlog::LV = T.let(T.unsafe(nil), T::Hash[Symbol, Integer])

# ---------
# LambdaExt
# LoggerFn = T.type_alias { T.proc.params(msg: T.untyped).void }

# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/Documentation
# typed: true

class Object
  sig { void }
  def log_dbg; end

  sig { void }
  def log_info; end

  sig { void }
  def log_warn; end

  sig { void }
  def log_err; end

  sig { void }
  def log_fatal; end

  sig { void }
  def log_unk; end
end

class Object
  sig { void }
  def dbg; end

  sig { void }
  def info; end

  sig { void }
  def warn; end

  sig { void }
  def err; end

  sig { void }
  def fatal; end

  sig { void }
  def unk; end
end

# -----
LevelType = T.type_alias { T.nilable(T.any(String, Integer, Symbol)) }

module Sinlog
  module_function # rubocop:disable Lint/UselessAccessModifier,Style/ModuleFunction

  sig { params(level: LevelType).returns(T.untyped) }
  def to_log_level(level); end

  sig { returns(Sinlog::Logger) }
  def instance; end

  sig { params(env_name: T.nilable(String), level: LevelType).returns(::Logger) }
  def logger(env_name: nil, level: nil); end
end
