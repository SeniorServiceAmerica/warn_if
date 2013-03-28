require_relative '../test_helper'

describe ModelWarnings do
  describe "instantiation" do
    before do
      @it = ModelWarnings.new
    end

    it "is hash-like" do
      [:keys,:values,:each].each do |method|
        @it.must_respond_to(method)
      end
    end

    it "has a key :base on instantiation" do
      @it.keys.must_include(:base)
    end
  end

  describe "population" do
    before do
      @it = ModelWarnings.new
    end

    describe "accepts new warnings with the add method" do
      it "adds new keys when needed" do
        @it.keys.wont_include(:new_warning)
        @it.add(:new_warning, "warned")
        @it.keys.must_include(:new_warning)
      end

      it "adds" do
        (@it.add(:foo, "Uh oh")).must_equal ["Uh oh"]
        (@it[:foo] = "Now you've done it").must_equal "Now you've done it"
        (@it.add("foo", "Again?")).must_equal ["Uh oh", "Now you've done it", "Again?"]
        (@it["foo"] = "Still").must_equal "Still"
        @it[:foo].must_equal ["Uh oh", "Now you've done it", "Again?", "Still"]
        @it[:foo].must_equal @it["foo"]
      end
    end
  end
end
