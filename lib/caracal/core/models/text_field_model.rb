require 'caracal/core/models/base_model'
require 'caracal/core/models/link_model'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # text field data.
      #
      class TextFieldModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants

        const_set(:DEFAULT_TEXT_FIELD_TEXT_CONTENT,    '')
        const_set(:DEFAULT_TEXT_FIELD_OFFSET_H,        0)           # units in pixels.
        const_set(:DEFAULT_TEXT_FIELD_OFFSET_V,        0)           # units in pixels.
        const_set(:DEFAULT_TEXT_FIELD_TOP,             0)           # units in pixels.
        const_set(:DEFAULT_TEXT_FIELD_BOTTOM,          0)           # units in pixels.
        const_set(:DEFAULT_TEXT_FIELD_LEFT,            0)           # units in pixels.
        const_set(:DEFAULT_TEXT_FIELD_RIGHT,           0)           # units in pixels.
        const_set(:DEFAULT_TEXT_FIELD_RELATIVE_FROM_H, :left_margin)
        const_set(:DEFAULT_TEXT_FIELD_RELATIVE_FROM_V, :top_margin)
        const_set(:DEFAULT_TEXT_FIELD_LOCK,            false)
        const_set(:DEFAULT_TEXT_FIELD_WRAP,            :largest)


        attr_reader :text_field_top
        attr_reader :text_field_bottom
        attr_reader :text_field_left
        attr_reader :text_field_right

        # @!attributes [r] text_field_width
        #   @return [Integer] The width of the text field
        attr_reader :text_field_width

        # @!attributes [r] text_field_height
        #   @return [Integer] The height of the text field
        attr_reader :text_field_height

        # @!attributes [r] text_field_offset_h
        #   @return [Integer] Offset for horizontal positioning
        attr_reader :text_field_offset_h

        # @!attributes [r] text_field_offset_v
        #   @return [Integer] Offset for vertical positioning
        attr_reader :text_field_offset_v

        # @!attributes [r] text_field_relative_from_h
        #   @return [Symbol] Base for absolute horizontal positioning. Valid
        #     params: column, character, left_margin, right_margin,
        #     inside_margin, outside_margin,
        attr_reader :text_field_relative_from_h

        # @!attributes [r] text_field_relative_from_v
        #   @return [Symbol] Base for absolute vertical positioning. Valid
        #     params: margin, page, paragraph, line, top_margin, bottom_margin,
        #     inside_margin, outside_margin
        attr_reader :text_field_relative_from_v

        # @!attributes [r] text_field_wrap
        #   @return [Symbol] Info about how to wrap text around text_field.
        #     Valid params: :none, :square_both_sides, :square_largest,
        #     :square_left, :square_right, :top_and_bottom
        attr_reader :text_field_wrap

        # @!attributes [r] text_field_lock
        #   @return [Boolean] Indicates whether text field should be locked.
        attr_reader :text_field_lock


        # initialization
        def initialize(options={}, &block)
          @text_field_text_content    = DEFAULT_TEXT_FIELD_TEXT_CONTENT
          @text_field_offset_h        = DEFAULT_TEXT_FIELD_OFFSET_H
          @text_field_offset_v        = DEFAULT_TEXT_FIELD_OFFSET_V
          @text_field_relative_from_h = DEFAULT_TEXT_FIELD_RELATIVE_FROM_H
          @text_field_relative_from_v = DEFAULT_TEXT_FIELD_RELATIVE_FROM_V
          @text_field_lock            = DEFAULT_TEXT_FIELD_LOCK
          @text_field_wrap            = DEFAULT_TEXT_FIELD_WRAP

          super options, &block
        end

        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== GETTERS ==============================

        [:width, :height].each do |m|
          define_method "formatted_#{ m }" do
            value = send("text_field_#{ m }")
            pixels_to_emus(value, 72)
          end
        end

        [:top, :bottom, :left, :right, :offset_h, :offset_v].each do |m|
          define_method "formatted_#{ m }" do
            value = send("text_field_#{ m }")
            pixels_to_emus(value, 72)
          end
        end


        #=============== SETTERS ==============================

        # integers
        [:top, :bottom, :left, :right, :height, :offset_h, :offset_v, :width].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_field_#{ m }", value.to_i)
          end
        end

        # strings
        [:text_content].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_field_#{ m }", value.to_s)
          end
        end

        # symbols
        [:wrap, :relative_from_h, :relative_from_v].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_field_#{ m }", value.to_s.to_sym)
          end
        end

        # miscellaneous
        [:lock].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@text_field_#{ m }", value)
          end
        end

        #========== VALIDATION ============================

        def valid?
          dims = [:width, :height].map { |m| send("text_field_#{ m }") }
          dims.all? { |d| d > 0 }
        end


        #--------------------------------------------------
        # Private Methods
        #--------------------------------------------------
        private

        def option_keys
          [:text, :height, :lock, :offset_h, :offset_v, :relative_from_h, :relative_from_v, :width]
        end

        def pixels_to_emus(value, ppi)
          pixels        = value.to_i
          inches        = pixels / ppi.to_f
          emus_per_inch = 914400

          emus = (inches * emus_per_inch).to_i
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
