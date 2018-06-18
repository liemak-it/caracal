require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models

      class TextFieldGroupModel < BaseModel

        attr_reader :text_field_counter

        # initialization
        def initialize(options={}, &block)
          super options, &block
        end

        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== GETTERS ==============================

        def text_field_models
          @text_field_models ||= []
        end

        #=============== SETTERS ==============================

        def text_fields(text_fields_data)
          text_fields_data.each do |text_field_data|
            id = text_field_counter.to_i + 1
            @text_field_counter = id

            options = text_field_data[:text_field]
            options.merge!({ id: id, name: "Textfield #{id}" })

            text_field_model = Caracal::Core::Models::TextFieldModel.new(options)
            text_field_models.push(text_field_model)
          end
        end

        #========== VALIDATION ============================

        def valid?
          true
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          []
        end

        def method_missing(method, *args, &block)
          # I'm on the fence with respect to this implementation. We're ignoring
          # :method_missing errors to allow syntax flexibility for paragraph-type
          # models.  The issue is the syntax format of those models--the way we pass
          # the content value as a special argument--coupled with the model's
          # ability to accept nested instructions.
          #
          # By ignoring method missing errors here, we can pass the entire paragraph
          # block in the initial, built-in call to :text.
        end

      end

    end
  end
end
