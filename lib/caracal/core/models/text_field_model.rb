require 'caracal/core/models/base_model'
require 'caracal/core/models/link_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text field data.
      #
      class TextFieldModel < BaseModel

        #--------------------------------------------------
        # Configuration
        #--------------------------------------------------

        # accessors


        #--------------------------------------------------
        # Public Methods
        #--------------------------------------------------

        #========== GETTERS ===============================

        # .run_attributes
        def run_attributes
          {}
        end


        #========== SETTERS ===============================

        #=============== SUB-METHODS ===========================

        # .text_field
        def text_field
          model = Caracal::Core::Models::LineBreakModel.new()
          runs << model
          model
        end



        #========== VALIDATION ============================

        def valid?
          a = [:content]
          a.map { |m| send("text_#{ m }") }.compact.size == a.size
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [:content]
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
