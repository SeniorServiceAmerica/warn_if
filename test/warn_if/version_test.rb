require_relative '../test_helper'

describe WarnIf do
  it "must have a version" do
    WarnIf::VERSION.wont_be_nil
  end
end
