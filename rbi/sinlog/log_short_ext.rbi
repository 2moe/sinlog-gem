# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/Documentation
# typed: true

class Sinlog
  module LogShortExt
    refine Object do
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
  end
end
