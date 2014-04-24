require_relative 'minitest_helper'

describe String do
  describe "underscore" do
    it "should not modify all lower case words" do
      "test".underscore.must_equal("test")
    end

    it "should converte camelcase to underscored lower case words" do
      "UnitTest".underscore.must_equal("unit_test")
    end
  end
end
