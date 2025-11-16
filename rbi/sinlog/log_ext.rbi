# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/Documentation
# typed: true

class Sinlog
  module LogExt
    refine Object do
      sig { void }
      def log_dbg; end
    end

    refine Object do
      sig { void }
      def log_info; end
    end

    refine Object do
      sig { void }
      def log_warn; end
    end

    refine Object do
      sig { void }
      def log_err; end
    end

    refine Object do
      sig { void }
      def log_fatal; end
    end

    refine Object do
      sig { void }
      def log_unk; end
    end
  end
end
