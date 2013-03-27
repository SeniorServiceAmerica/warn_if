class ModelWarnings < Hash
  def initialize
    super
    self[:base] = []
    self
  end

  def all
    values.flatten
  end

  def clear
    # self.keys.each {|k| self[k] = []}
    super
    self[:base] = []
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
end
