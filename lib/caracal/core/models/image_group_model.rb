require 'caracal/core/models/base_model'

module Caracal
  module Core
    module Models

      class ImageGroupModel < BaseModel

        attr_reader :image_counter

        # initialization
        def initialize(options={}, &block)
          super options, &block
        end

        #-------------------------------------------------------------
        # Public Methods
        #-------------------------------------------------------------

        #=============== GETTERS ==============================

        def image_models
          @image_models ||= []
        end

        #=============== SETTERS ==============================

        def images(images_data)
          images_data.each do |image_data|
            id = image_counter.to_i + 1
            @image_counter = id

            options = image_data[:img]
            options.merge!({ id: id, name: "Image #{id}" })

            image_model = Caracal::Core::Models::ImageModel.new(options)
            image_models.push(image_model)
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
