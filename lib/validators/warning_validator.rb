class WarningValidator < ActiveModel::Validator
  def validate(record)
    if warning_condition?(record)
      record.warnings[:base] << ModelWarning.new(options[:label],options[:message],options[:severity],new_condition?(record))
    end
  end

  def warning_condition?(record)
    if options[:condition].respond_to?(:call)
      options[:condition].call(record)
    else
      record.method(options[:condition]).call
    end
  end

  def new_condition?(record)
    options[:new_condition].call(record)
  end
end
