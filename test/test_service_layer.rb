require_relative 'minitest_helper'

describe ServiceLayer do
  before do
    if defined?(Services)
      Services.constants.each do |const|
        Services.send(:remove_const, const)
      end
      Object.send(:remove_const, :Services)
    end
    ServiceLayer::Locator.reset!
  end

  describe "#collect_services!" do
    it "should do nothing if there is no Services namespace" do
      ServiceLayer.collect_services!
      ServiceLayer::Locator.services.must_equal([])
    end

    it "should auto register anything in the Services namespace that has a class name ending in Service" do
      module Services
        class FooService
        end
      end
      ServiceLayer.collect_services!
      ServiceLayer::Locator.services.must_equal([:foo_service])
    end

    it "should not auto register anything in the Services namespace that does not have a class name ending in Service" do
      module Services
        class Foo
        end
      end
      ServiceLayer.collect_services!
      ServiceLayer::Locator.services.wont_include(:foo)
    end
  end
end

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
