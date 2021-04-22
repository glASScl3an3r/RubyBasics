# frozen_string_literal: true

module Validation
  def self.included(base)
    base.send(:include, InstanceMethods)
    base.extend(ClassMethods)
  end

  module InstanceMethods
    def valid?
      begin
        validate!
      rescue StandardError
        return false
      end
      true
    end

    def validate!
      self.class.validators.each { |args| validate(args) }
    end

    private

    def validate(args)
      value = instance_variable_get("@#{args[0]}".to_sym)
      #format: [variable_name, validation_type(may be useful), format||type||etc]
      send("validate_#{args[1]}".to_sym, value, *args)
    end

    def validate_presence(value, name, _valid_type)
      raise "#{name} was nil" if value.nil?
      raise "#{name} was empty string" if value.empty?
    end

    def validate_format(value, name, _valid_type, format)
      raise "#{name} does not match the format #{format}" if value !~ format
    end

    def validate_type(value, name, _valid_type, type)
      raise "#{name} was #{value.class}, but should have been #{type}" if value.class != type
    end
  end

  module ClassMethods
    def validate(*args)
      validators.push(args)
    end

    def validators
      # если есть валидаторы для родительских классов, нам они нужны
      @validators ||= superclass.validators.clone if superclass.methods.find { |method| method == :validators }
      @validators ||= []
    end
  end
end
