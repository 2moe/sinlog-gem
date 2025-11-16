# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/Documentation
# typed: true

class Sinlog
  include ::Singleton::SingletonInstanceMethods
  include ::Singleton
  extend ::Singleton::SingletonClassMethods

  sig { params(level: Integer).returns(Logger) }
  def self.logger_with_level(level = LV[:warn]); end

  sig { returns(Logger) }
  def self.logger; end

  sig { returns(Logger) }
  def logger; end

  sig { params(env_name: String).returns(NilClass) }
  def set_level_from_env!(env_name = ''); end

  private

  sig { params(progname: T.any(String, Symbol)).returns(String) }
  def format_prog_name(progname); end
end

Sinlog::COLORS = T.let(T.unsafe(nil), T::Hash[Symbol, String])

Sinlog::LV = T.let(T.unsafe(nil), T::Hash[Symbol, Integer])

# ---------
# LambdaExt
# LoggerFn = T.type_alias { T.proc.params(msg: T.untyped).void }
