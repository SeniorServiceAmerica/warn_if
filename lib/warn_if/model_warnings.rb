class ModelWarnings < Hash
  def initialize
    super
    initial_setup
    self
  end

  def all
    values.flatten
  end

  def clear
    super
    initial_setup
  end

  def clear?
    keys == [:base] && self[:base] == []
  end

  def new
    all.select {|w| w.new?}
  end

  def with_severity(severity)
    all.select {|w| w.severity == severity}
  end

  private

  def initial_setup
    self[:base] = []
  end
end
