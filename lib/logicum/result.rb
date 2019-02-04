module Logicum
  module Interactor

    class Result
      def initialize
        @success = true
        @error = ''
      end

      def success?
        @success
      end

      def failure?
        !success?
      end

      def fail!(message = '')
        @success = false
        @error = message
      end

      def error
        @error.dup
      end
    end

  end
end

