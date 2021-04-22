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
      var = instance_variable_get("@#{args[0]}".to_sym)

      case args[1]
      when :presence
        valid_presence(args[0], var)
      when :format
        valid_format(args[0], var, args[2])
      when :type
        valid_type(args[0], var, args[2])
      end
    end

    def valid_presence(name, value)
      raise "#{name} was nil" if value.nil?
      raise "#{name} was empty string" if value.empty?
    end

    def valid_format(name, value, format)
      raise "#{name} does not match the format #{format}" if value !~ format
    end

    def valid_type(_name, value, type)
      raise "#value was #{value.class}, but should have been #{type}" if value.class != type
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
