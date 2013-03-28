require_relative '../test_helper'

describe ModelWarning do
  describe "instantiation" do
    it "requires a label, message and severity" do
      ModelWarning.new('label','message','severity').must_be_instance_of(ModelWarning)
    end

    it "also accepts a new_warning flag" do
      ModelWarning.new('label','message','severity',false).must_be_instance_of(ModelWarning)
    end

    it "sets new_warning to false if it is not provided" do
      ModelWarning.new('label','message','severity').new?.must_equal(false)
    end
  end

  describe "attributes" do
    before do
      @it = ModelWarning.new('label','message','severity')
    end

    it "returns a label" do
      @it.must_respond_to(:label)
    end

    it "returns a message" do
      @it.must_respond_to(:message)
    end

    it "returns a severity" do
      @it.must_respond_to(:severity)
    end

    it "aliases new_warnings as new?" do
      [true, false].each do |p|
        @it = ModelWarning.new('label','message','severity',p)
        @it.new?.must_equal(p)
      end
    end
  end
end
