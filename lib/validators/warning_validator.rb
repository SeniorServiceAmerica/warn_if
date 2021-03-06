class WarningValidator < ActiveModel::Validator
  def validate(record)
    if warning_condition?(record)
      record.warnings[:base] << ModelWarning.new(options[:label],message(record),options[:severity],new_condition?(record))
    end
  end

  def warning_condition?(record)
    if options[:condition].respond_to?(:call)
      options[:condition].call(record)
    else
      record.method(options[:condition]).call
    end
  end

  def message(record)
    if options[:message].respond_to?(:call)
      options[:message].call(record)
    elsif record.respond_to?(options[:message])
      record.method(options[:message]).call
    else
      options[:message].to_s
    end
  end

  def new_condition?(record)
    if options[:new_condition].respond_to?(:call)
      options[:new_condition].call(record)
    else
      record.method(options[:new_condition]).call
    end
  end
end
