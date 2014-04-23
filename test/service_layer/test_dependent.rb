require_relative '../minitest_helper'

describe ServiceLayer::Dependent do
  class TestDependent
    extend ServiceLayer::Dependent
  end
  before do
    ServiceLayer::Locator.reset!
  end
  let(:locator) {ServiceLayer::Locator}

  describe "#services" do
    it "should allow declaration of dependence on a single service" do
      locator.register(:foo, "foo")
      TestDependent.services :foo
      TestDependent.new.foo.must_equal("foo")
    end

    it "should allow declaration of dependence on multiple services" do
      locator.register(:bar, "bar")
      locator.register(:baz, "baz")
      TestDependent.services :bar, :baz
      TestDependent.new.bar.must_equal("bar")
      TestDependent.new.baz.must_equal("baz")
    end

    it "should allow initialization args to be passed to service accessors" do
      locator.register(:my_service, Struct.new(:a))
      TestDependent.services :my_service
      TestDependent.new.my_service(1).a.must_equal(1)
    end

    it "should allow declaration of dependence on a service that is instantiated once and memoized thereafter" do
      locator.register(:memoized_service, Object)
      TestDependent.services :memoized_service, memoized: true
      dependent = TestDependent.new
      dependent.memoized_service.object_id
        .must_equal(dependent.memoized_service.object_id)
    end
  end
end
