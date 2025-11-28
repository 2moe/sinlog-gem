# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/Documentation
# typed: true

class Sinlog
  module LogExt
    refine Object do
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
  end
end
