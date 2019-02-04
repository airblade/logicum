# https://github.com/hanami/utils/blob/master/lib/hanami/utils/class_attribute.rb

require 'set'

module Logicum
  module ClassAttribute

    def self.included(base)
      base.extend ClassMethods
    end


    module ClassMethods
      def class_attribute(*attributes)
        singleton_class.class_eval do
          attr_accessor *attributes
        end

        class_attributes.merge attributes
      end

      protected

      def inherited(subclass)
        class_attributes.each do |attribute|
          value = send(attribute).dup
          subclass.class_attribute attribute
          subclass.send "#{attribute}=", value
        end

        super
      end

      private

      def class_attributes
        @class_attributes ||= Set.new
      end
    end

  end
end
