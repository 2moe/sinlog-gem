# rubocop:disable Style/FrozenStringLiteralComment
# rubocop:disable Style/Documentation
# typed: true

class Sinlog
  module LogExt
    refine Object do
      sig { void }
      def dbg; end
    end

    refine Object do
      sig { void }
      def info; end
    end

    refine Object do
      sig { void }
      def warn; end
    end

    refine Object do
      sig { void }
      def err; end
    end

    refine Object do
      sig { void }
      def fatal; end
    end

    refine Object do
      sig { void }
      def unk; end
    end
  end
end
