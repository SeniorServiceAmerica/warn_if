require_relative '../test_helper'

describe WarningValidator do
  let(:record)   { TestModel.new(rand(10)) }
  let(:options) { Hash[] }

  subject       { WarningValidator.new(options) }

  describe "#warning_condition?" do
    describe "when options[:condition] value is the name of a method" do
      let(:condition_method) { :even? }
      before do
        options[:condition] = condition_method
      end
      
      it "sends the method to the object being validated" do
        subject.warning_condition?(record).must_equal record.send(condition_method)
      end
    end

    describe "when options[:condition] is callable object" do
      let(:life_the_universe_and_everything?) { Proc.new { |record| record.favorite_number == 42 } }
      before do
        options[:condition] = life_the_universe_and_everything?
      end

      it "returns the result of passing the record to object#call" do
        subject.warning_condition?(record).must_equal life_the_universe_and_everything?.call(record)
      end
    end
  end

  describe "#message" do
    describe "when options[:message] value is the name of a method" do
      let(:message_method) { :tell_me_your_favorite_number }
      before do
        options[:message] = message_method
      end

      it "sends the method to the object being validated" do
        subject.message(record).must_equal record.send(message_method)
      end
    end

    describe "when options[:message] is callable object" do
      let(:who_is_number_one) { Proc.new { |record| "You are number #{record.favorite_number}" } }
      before do
        options[:message] = who_is_number_one
      end

      it "returns the result of passing the record to object#call" do
        subject.message(record).must_equal who_is_number_one.call(record)
      end
    end

    describe "other values" do
      it "converts them to a string" do
        ["foo", :bar].each do |other|
          options = Hash[:message => other]
          warning_validator = WarningValidator.new(options)
          warning_validator.message(record).must_equal other.to_s
        end
      end
    end
  end

  describe "#new_condition?" do
    describe "when options[:new_condition] is the name of a method" do
      let(:new_condition_method) { :changed? }
      before do
        options[:new_condition] = new_condition_method
      end

      it "sends the method to the object being validated" do
        subject.new_condition?(record).must_equal record.send(new_condition_method)
      end
    end

    describe "when options[:new_condition] is callable object" do
      let(:new_condition_callable) { Proc.new { |record| record.favorite_number < 5 } }
      before do
        options[:new_condition] = new_condition_callable
      end

      it "calls the object with the record" do
        subject.new_condition?(record).must_equal options[:new_condition].call(record)
      end
    end
  end

  describe "#validate" do
    let(:options) { 
                    Hash[
                      :condition => Proc.new { true },
                      :on => :update,
                      :message => "foo",
                      :label => "bar",
                      :severity => "Attention",
                      :new_condition => Proc.new { |record| record.changed? }
                    ]
                  }
    let(:warning_validator) { WarningValidator.new(options) }

    before do
      def warning_validator.warning_condition?(record)
        true
      end
    end

    it "adds a new ModelWarning to warnings[:base] when warning_condition? is true" do
      record.warnings[:base].count.must_equal 0
      warning_validator.validate(record)
      record.warnings[:base][0].must_be_instance_of ModelWarning
    end

    it "sets the ModelWarning's message to the value of #message" do
      def warning_validator.message(record)
        "oh no, plaids and stripes!"
      end      
      warning_validator.validate(record)
      record.warnings[:base][0].message.must_equal warning_validator.message(record)
    end

    it "sets the ModelWarning's label to options[:label]" do
      warning_validator.validate(record)
      record.warnings[:base][0].label.must_equal options[:label]
    end

    it "sets the ModelWarning's severity to options[:severity]" do
      warning_validator.validate(record)
      record.warnings[:base][0].severity.must_equal options[:severity]
    end

    it "sets the ModelWarning's new? to the result of #new_condition?" do
      def warning_validator.new_condition?(record)
        false
      end
      warning_validator.validate(record)
      record.warnings[:base][0].new?.must_equal false

      def warning_validator.new_condition?(record)
        true
      end
      warning_validator.validate(record)
      record.warnings[:base][1].new?.must_equal true
    end

    it "does nothing when warning_condition? is false" do
      def warning_validator.warning_condition?(record)
        false
      end
      record.warnings[:base].count.must_equal 0
      warning_validator.validate(record)
      record.warnings[:base].count.must_equal 0
    end
  end

end


class TestModel 
  include WarnIf
  attr_accessor :favorite_number, :changed
  
  def initialize(favorite_number)
    self.favorite_number  = favorite_number
    self.changed          = [true, false].sample
  end

  def even?
    favorite_number.even?
  end

  def changed?
    changed
  end

  def tell_me_your_favorite_number
    "my favorite number is #{favorite_number}"
  end
end
