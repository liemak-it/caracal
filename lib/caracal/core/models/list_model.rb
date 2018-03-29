require 'caracal/core/models/base_model'
require 'caracal/core/models/list_item_model'
require 'caracal/errors'


module Caracal
  module Core
    module Models

      # This class encapsulates the logic needed to store and manipulate
      # list data.
      #
      class ListModel < BaseModel

        #-------------------------------------------------------------
        # Configuration
        #-------------------------------------------------------------

        # constants
        const_set(:DEFAULT_LIST_TYPE,  :unordered)
        const_set(:DEFAULT_LIST_LEVEL, 0)
        const_set(:DEFAULT_LIST_NO_BULLETS, false)
        const_set(:DEFAULT_LIST_WITH_BRACKETS, false)

        # accessors
        attr_reader :list_type
        attr_reader :list_level
        attr_reader :list_no_bullets
        attr_reader :list_with_brackets


        # initialization
        def initialize(options={}, &block)
          @list_type          = DEFAULT_LIST_TYPE
          @list_level         = DEFAULT_LIST_LEVEL
          @list_no_bullets    = DEFAULT_LIST_NO_BULLETS
          @list_with_brackets = DEFAULT_LIST_WITH_BRACKETS

          super options, &block
        end


        #-------------------------------------------------------------
        # Public Instance Methods
        #-------------------------------------------------------------

        #=============== GETTERS ==============================

        # This method returns only those items owned directly
        # by this list.
        #
        def items
          @items ||= []
        end

        # This method returns a hash, where the keys are levels
        # and the values are the list type at that level.
        #
        def level_map
          recursive_items.reduce({}) do |hash, item|
            hash[item.list_item_level] = item.list_item_type
            hash
          end
        end

        # This method returns a flattened array containing every
        # item within this list's tree.
        #
        def recursive_items
          items.map do |model|
            if model.nested_list.nil?
              model
            else
              [model, model.nested_list.recursive_items]
            end
          end.flatten
        end


        #=============== SETTERS ==============================

        # integers
        [:level].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@list_#{ m }", value.to_i)
          end
        end

        # symbols
        [:type].each do |m|
          define_method "#{ m }" do |value|
            instance_variable_set("@list_#{ m }", value.to_s.to_sym)
          end
        end

        # booleans
        [:no_bullets, :with_brackets].each do |m|
          define_method"#{ m }" do |value|
            instance_variable_set("@list_#{m}", !!value)
          end
        end

        # Convenient method to create list elements using an array
        def list_items(list_elements)
          @items = items
          puts
          puts "self: #{self.inspect}"
          puts "list_with_brackets: #{list_with_brackets.inspect}"
          options = { type: list_type, level: 0, no_bullets: list_no_bullets, with_brackets: list_with_brackets }
          puts ">>> options: #{options.inspect}"
          puts "list_elements: #{list_elements.inspect}"
          list_elements.each do |item|
            puts
            puts "BEFORE options: #{options.inspect}"
            options[:content] = item
            puts "AFTER options: #{options.inspect}"
            @items.push(Caracal::Core::Models::ListItemModel.new(options))
          end
        end

        #=============== SUB-METHODS ===========================

        # .li
        def li(*args, &block)
          options = Caracal::Utilities.extract_options!(args)
          options.merge!({ content: args.first }) if args.first
          options.merge!({ type:    list_type  })
          options.merge!({ level:   list_level })

          model = Caracal::Core::Models::ListItemModel.new(options, &block)
          if model.valid?
            items << model
          else
            raise Caracal::Errors::InvalidModelError, 'List item must have at least one run.'
          end
          model
        end


        #=============== VALIDATION ===========================

        def valid?
          a = [:type, :level]
          required = a.map { |m| send("list_#{ m }") }.compact.size == a.size
          required && !items.empty?
        end


        #-------------------------------------------------------------
        # Private Instance Methods
        #-------------------------------------------------------------
        private

        def option_keys
          [:type, :level, :list_items, :no_bullets, :with_brackets]
        end

      end

    end
  end
end
