require 'logicum/class_attribute'
require 'logicum/result'
require 'logicum/errors'

module Logicum
  module Interactor

    def self.included(base)
      base.extend ClassMethods
      base.prepend CallInterface
    end


    module ClassMethods
      def self.extended(base)
        base.class_eval do
          include ClassAttribute
          class_attribute :provisions
          self.provisions = []
        end
      end

      def provides(*instance_variable_names)
        provisions.concat instance_variable_names
      end

      # Shortcut for caller if nothing needed in initializer.
      # For example:
      #
      #     AddUser.call foo: 'bar'
      #
      # is equivalent to:
      #
      #     AddUser.new.call foo: 'bar'
      def call(*args, **kwargs, &block)
        new.call *args, **kwargs, &block
      end
    end


    module CallInterface
      def call(*, **)
        raise MissingCallError unless defined? super

        @__result__ = Result.new

        begin
          super
        rescue StandardError => e
          @__result__.fail! e.message
        end

        self.class.provisions.each do |attr|
          ivar_name = "@#{attr}"
          if instance_variable_defined? ivar_name
            val = instance_variable_get ivar_name
            @__result__.define_singleton_method(attr) { val }
          else
            # Calling code must ensure instance variables to provide are
            # set before any code which could raise an exception.
            raise ProvisionError, "#{ivar_name} was not set in call() method"
          end
        end

        @__result__
      end
    end


    def fail!(message = '')
      @__result__.fail! message
    end

  end
end
