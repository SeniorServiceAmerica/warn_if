require 'forwardable'

class ModelWarnings
  include Enumerable
  extend Forwardable
  def_delegators :@warnings, :keys, :values, :each
  attr_reader :warnings

  def initialize
    @warnings = {}
    initial_setup
    self
  end

  def add(attribute, warning)
    self[attribute.to_sym] << warning
  end

  def [](attribute)
    get(attribute.to_sym) || set(attribute.to_sym, [])
  end

  def []=(attribute, warning)
    self[attribute] << warning
  end

  def get(key)
    warnings[key]
  end

  def set(key, value)
    warnings[key] = value
  end

  def all
    values.flatten
  end

  def clear
    warnings.clear
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
    @warnings[:base] = []
  end
end
