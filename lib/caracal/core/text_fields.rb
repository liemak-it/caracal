require 'caracal/core/models/text_field_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to adding text
    # fields to the document.
    #
    module TextFields
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

          def text_field(*args, &block)
            id = text_field_counter.to_i + 1
            @text_field_counter = id

            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ content: args.first }) if args.first
            options.merge!({ id: id, name: "Textfield #{id}" })

            model = Caracal::Core::Models::TextFieldModel.new(options, &block)
            if model.valid?
              contents << model
            else
              raise Caracal::Errors::InvalidModelError, 'Paragraphs and headings, which delegate to the :p command, require at least one text string.'
            end
            model
          end
        end
      end
    end

  end
end
