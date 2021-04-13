module InstanceCounter
  module ClassMethods
    attr_accessor :insts

    def inherited(subclass)
      subclass.instance_eval do
        @insts = []
      end
    end

    def all
      insts || []
    end

    def instances
      self.insts.count
    end

    def add_instance(instance)
      cls = self

      cls.insts = cls.insts.to_a << instance
    end
  end

  module InstanceMethods
    protected

    def register_instance
      cls = self.class

      cls.add_instance(self)

      loop do
        cls = cls.superclass

        break unless cls.included_modules.include?(InstanceCounter)

        cls.add_instance(self)
      end
    end
  end

  def self.included(base)
    base.extend(ClassMethods)
    base.send(:include, InstanceMethods)
  end
end