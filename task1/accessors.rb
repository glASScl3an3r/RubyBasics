# frozen_string_literal: true

module Accessors
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def attr_accessor_with_history(*names)
      names.each do |name|
        var_name = "@#{name}".to_sym
        var_name_history = "@#{name}_history".to_sym
        # getter
        define_method(name) { instance_variable_get(var_name) }
        # setter
        define_method("#{name}=".to_sym) do |value|
          instance_variable_set(var_name, value)
          send("#{name}_history".to_sym).push(instance_variable_get(var_name))
        end
        # get history
        define_method("#{name}_history".to_sym) do
          instance_variable_set(var_name_history, []) if
            instance_variable_get(var_name_history).nil?

          instance_variable_get(var_name_history)
        end
      end
    end

    def strong_attr_accessor(*typenames)
      (0..typenames.count / 2 - 1).each do |i|
        cur_name = typenames[i * 2]
        cur_type = typenames[i * 2 + 1]

        var_name = "@#{cur_name}".to_sym
        #getter
        define_method(cur_name) { instance_variable_get(var_name) }
        #setter
        define_method("#{cur_name}=".to_sym) do |value|
          raise "Invalid value type: #{value.class} given but #{cur_type} expected" if
            value.class != cur_type

          instance_variable_set(var_name, value)
        end
      end
    end
  end
end
