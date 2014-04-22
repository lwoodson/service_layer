require_relative '../minitest_helper'

describe ServiceLayer::Locator do
  subject {ServiceLayer::Locator}
  before {subject.reset!}
  describe "#lookup" do
    it "should be allowed to lookup instances of a service class by key" do
      subject.register(:foo, Array)
      subject.lookup(:foo).must_be_instance_of(Array)
    end

    it "should be allowed to lookup instances of a service class populated with constructor args" do
      subject.register(:foo, Struct.new(:a, :b))
      service = subject.lookup(:foo, 1, 2)
      service.a.must_equal(1)
      service.b.must_equal(2)
    end

    it "should be allowed to lookup instances of a service by key" do
      service = Object.new
      subject.register(:foo, service)
      subject.lookup(:foo).must_equal(service)
    end

    it "should raise NotFoundError if attempting to lookup service with unregistered key" do
      lambda {subject.lookup(:foo)}.must_raise(ServiceLayer::NotFoundError)
    end
  end
end
