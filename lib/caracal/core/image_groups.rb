require 'caracal/core/models/text_field_group_model'
require 'caracal/errors'


module Caracal
  module Core

    # This module encapsulates all the functionality related to adding images
    # to the document.
    #
    module ImageGroups
      def self.included(base)
        base.class_eval do

          #-------------------------------------------------------------
          # Configuration
          #-------------------------------------------------------------

          # @!attributes [r] image_counter
          #   @return [Integer|Nil]
          attr_reader :image_counter


          #-------------------------------------------------------------
          # Public Methods
          #-------------------------------------------------------------

          def image_group(*args, &block)
            id = image_counter.to_i + 1
            @image_counter = id

            options = Caracal::Utilities.extract_options!(args)
            options.merge!({ content: args.first }) if args.first

            model = Caracal::Core::Models::ImageGroupModel.new(options, &block)
            contents << model

            model
          end
        end
      end
    end

  end
end
