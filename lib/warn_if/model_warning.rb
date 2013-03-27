class ModelWarning
  attr_accessor :label, :message, :severity
  def initialize(label, message, severity, new_warning=false)
    self.label       = label
    self.message     = message
    self.severity    = severity
    self.new_warning = new_warning
  end

  def new?
    new_warning
  end

  private
  attr_accessor :new_warning
end
