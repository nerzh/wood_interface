module WoodInterface

  class InterfaceNotImplementedError < NoMethodError; end
  class InterfaceArgumentError       < ArgumentError; end



  def self.included(klass)
    @@global_interfaces ||= Hash.new { |hash, key| hash[key] = {} }

    def klass.add_methods_to(type_methods, name, arguments)
      @@global_interfaces[self.to_s][type_methods]     ||= {}
      @@global_interfaces[self.to_s][type_methods][name] = arguments
    end

    def klass.add_methods_to(type_methods, name, arguments)
      @@global_interfaces[self.to_s][type_methods]     ||= {}
      @@global_interfaces[self.to_s][type_methods][name] = arguments
    end

    klass.extend ClassMethods
    klass.include InstanceMethods
  end



  module ClassMethods
    private

    def required_method(name, **arguments)
      add_methods_to('required_methods', name, arguments)
    end

    def method(name, **arguments)
      add_methods_to('methods', name, arguments)
    end

    def methods(&block)
      block.call
    end
  end



  module InstanceMethods

    def initialize(*n)
      interfaces.each do |ntrfc_name|
        interfaces_methods[ntrfc_name].each do |type_methods, mthds|
          check_all(ntrfc_name, type_methods, mthds)
        end
        interfaces_methods.delete(ntrfc_name)
      end
      super
    end

    private

    def check_all(ntrfc_name, type_methods, mthds)
      case type_methods
        when 'required_methods' then check_required_methods(ntrfc_name, mthds)
        when 'methods'          then check_methods(ntrfc_name, mthds)
      end
    end

    def check_methods(ntrfc_name, mthds)
      mthds.each do |name, arguments|
        check_arguments(ntrfc_name, name, arguments)
      end
    end

    def check_required_methods(ntrfc_name, mthds)
      mthds.each do |name, arguments|
        check_method(ntrfc_name, name)
        check_arguments(ntrfc_name, name, arguments)
      end
    end

    def check_method(ntrfc_name, name)
      unless respond_to?(name)
        raise WoodInterface::InterfaceNotImplementedError.new("#{self.class.to_s} needs to implement method '#{name}' for interface #{ntrfc_name}!")
      end
    end

    def check_arguments(ntrfc_name, name, arguments)
      unless check_arity(method(name), arguments)
        raise WoodInterface::InterfaceArgumentError.new("ArgumentError in inplemented method '#{self.class.to_s}'-'#{name}' for interface #{ntrfc_name} given #{method(name).arity.abs}, expected #{arguments.keys.size} !")
      end
    end

    def check_arity(method, arguments)
      method.arity.abs == arguments.keys.size
    end

    def interfaces_methods
      self.class.class_variable_get(:@@global_interfaces)
    end

    def interfaces
      interfaces = []
      self.class.ancestors.each { |klass| break if klass == Interface; interfaces << klass.to_s }
      interfaces
    end
  end
end