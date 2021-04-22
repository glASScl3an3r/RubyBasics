# frozen_string_literal: true

module Accessors
  def attr_accessor_with_history(*names)
    names.each do |name|
      class_eval("""
        def #{name}
          @#{name}
        end

        def #{name}=(value)
          @#{name}_history ||= []
          @#{name}_history << value
          @#{name} = value
        end

        def #{name}_history
          @#{name}_history || []
        end
      """)
    end
  end

  def strong_attr_accessor(*typenames)
    (0..typenames.count / 2 - 1).each do |i|
      cur_name = typenames[i * 2]
      cur_type = typenames[i * 2 + 1]

      class_eval("""
        def #{cur_name}
          @#{cur_name}
        end

        def #{cur_name}=(value)
          raise \"Incorrect value type: #{cur_type} expected but \" + value.class.to_s + \" given \" if value.class != #{cur_type}
          @#{cur_name} = value
        end
      """)
    end
  end
end
