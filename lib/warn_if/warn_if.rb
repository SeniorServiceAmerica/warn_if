module WarnIf
  module ClassMethods
    def warn_if(options={})
      validates_with WarningValidator, options
    end
  end

  module InstanceMethods
    def warnings
      @warnings ||= ModelWarnings.new
    end

    def warned?
      !warnings.empty?
    end

    def valid?(context = nil)
      warnings.clear
      super(context)
    end
  end

  def self.included(receiver)
    receiver.extend         ClassMethods
    receiver.send :include, InstanceMethods
  end
end
