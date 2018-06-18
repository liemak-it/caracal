require 'caracal/core/models/text_field_group_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to adding text
    # fields to the document.
    #
    module TextFieldGroups
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------

          # @!attributes [r] text_field_counter
          #   @return [Integer|Nil]
          attr_reader :text_field_counter


          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def text_field_group(*args, &block)
            id = text_field_counter.to_i + 1
            @text_field_counter = id

            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ content: args.first }) if args.first

            model = Caracal::Core::Models::TextFieldGroupModel.new(options, &block)
            contents << model

            model
          end
        end
      end
    end

  end
end
