require 'caracal/core/models/base_model'


module Caracal
  module Core
    module Models

      # This class handles block options passed to the img method.
      #
      class ImageModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants
        const_set(:DEFAULT_IMAGE_PPI,             72)          # pixels per inch
        const_set(:DEFAULT_IMAGE_WIDTH,           0)           # units in pixels. (will cause error)
        const_set(:DEFAULT_IMAGE_HEIGHT,          0)           # units in pixels. (will cause error)
        const_set(:DEFAULT_IMAGE_ALIGN,           :left)
        const_set(:DEFAULT_IMAGE_TOP,             8)           # units in pixels.
        const_set(:DEFAULT_IMAGE_BOTTOM,          8)           # units in pixels.
        const_set(:DEFAULT_IMAGE_LEFT,            8)           # units in pixels.
        const_set(:DEFAULT_IMAGE_RIGHT,           8)           # units in pixels.
        const_set(:DEFAULT_IMAGE_POSITION,        :inline)
        const_set(:DEFAULT_IMAGE_OFFSET_H,        0)           # units in pixels.
        const_set(:DEFAULT_IMAGE_OFFSET_V,        0)           # units in pixels.
        const_set(:DEFAULT_IMAGE_RELATIVE_FROM_H, :left_margin)
        const_set(:DEFAULT_IMAGE_RELATIVE_FROM_V, :top_margin)
        const_set(:DEFAULT_IMAGE_WRAP,            :top_and_bottom)
        const_set(:DEFAULT_IMAGE_LOCK,            false)

        # accessors
        attr_reader :image_url
        attr_reader :image_data
        attr_reader :image_ppi
        attr_reader :image_width
        attr_reader :image_height
        attr_reader :image_align
        attr_reader :image_top
        attr_reader :image_bottom
        attr_reader :image_left
        attr_reader :image_right

        # @!attributes [r] image_position
        #   @return [Symbol] Method for controlling image placement. Valid
        #     params: :inline, :anchor
        attr_reader :image_position


        # Params for image positioning with :anchor

        # @!attributes [r] image_offset_h
        #   @return [Integer] Offset for absolute horizontal positioning
        attr_reader :image_offset_h

        # @!attributes [r] image_offset_v
        #   @return [Integer] Offset for absolute vertical positioning
        attr_reader :image_offset_v

        # @!attributes [r] image_relative_from_h
        #   @return [Symbol] Base for absolute horizontal positioning. Valid
        #     params: column, character, left_margin, right_margin,
        #     inside_margin, outside_margin,
        attr_reader :image_relative_from_h

        # @!attributes [r] image_relative_from_v
        #   @return [Symbol] Base for absolute vertical positioning. Valid
        #     params: margin, page, paragraph, line, top_margin, bottom_margin,
        #     inside_margin, outside_margin
        attr_reader :image_relative_from_v

        # @!attributes [r] image_wrap
        #   @return [Symbol] Info about how to wrap text around image. Valid
        #     params: :none, :square_both_sides, :square_largest, :square_left,
        #     :square_right, :top_and_bottom
        attr_reader :image_wrap

        # @!attributes [r] image_lock
        #   @return [Boolean] Indicates whether image should be locked.
        attr_reader :image_lock


        # initialization
        def initialize(options={}, &block)
          @image_ppi             = DEFAULT_IMAGE_PPI
          @image_width           = DEFAULT_IMAGE_WIDTH
          @image_height          = DEFAULT_IMAGE_HEIGHT
          @image_align           = DEFAULT_IMAGE_ALIGN
          @image_top             = DEFAULT_IMAGE_TOP
          @image_bottom          = DEFAULT_IMAGE_BOTTOM
          @image_left            = DEFAULT_IMAGE_LEFT
          @image_right           = DEFAULT_IMAGE_RIGHT
          @image_position        = DEFAULT_IMAGE_POSITION
          @image_offset_h        = DEFAULT_IMAGE_OFFSET_H
          @image_offset_v        = DEFAULT_IMAGE_OFFSET_V
          @image_relative_from_h = DEFAULT_IMAGE_RELATIVE_FROM_H
          @image_relative_from_v = DEFAULT_IMAGE_RELATIVE_FROM_V
          @image_wrap            = DEFAULT_IMAGE_WRAP
          @image_lock            = DEFAULT_IMAGE_LOCK

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== GETTERS ==============================

        [:width, :height].each do |m|
          define_method "formatted_#{ m }" do
            value = send("image_#{ m }")
            pixels_to_emus(value, image_ppi)
          end
        end

        [:top, :bottom, :left, :right, :offset_h, :offset_v].each do |m|
          define_method "formatted_#{ m }" do
            value = send("image_#{ m }")
            pixels_to_emus(value, 72)
          end
        end

        def relationship_target
          image_url || image_data
        end


        #=============== SETTERS ==============================

        # integers
        [:ppi, :width, :height, :top, :bottom, :left, :right, :offset_h, :offset_v].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value.to_i)
          end
        end

        # strings
        [:data, :url].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value.to_s)
          end
        end

        # symbols
        [:align, :wrap, :position, :relative_from_h, :relative_from_v].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value.to_s.to_sym)
          end
        end

        # miscellaneous
        [:lock].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@image_#{ m }", value)
          end
        end


        #=============== VALIDATION ==============================

        def valid?
          dims = [:ppi, :width, :height, :top, :bottom, :left, :right].map { |m| send("image_#{ m }") }
          dims.all? { |d| d > 0 }
        end



        #-------------------------------------------------------------
        # Private Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [
            :align,
            :bottom,
            :height,
            :left,
            :offset_h,
            :offset_v,
            :position,
            :relative_from_h,
            :relative_from_v,
            :right,
            :top,
            :url,
            :width,
            :wrap
          ]
        end

        def pixels_to_emus(value, ppi)
          pixels        = value.to_i
          inches        = pixels / ppi.to_f
          emus_per_inch = 914400

          emus = (inches * emus_per_inch).to_i
        end

      end

    end
  end
end
