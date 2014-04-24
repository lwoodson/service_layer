require_relative '../minitest_helper'

describe ServiceLayer::Service do
  describe "#included" do
    it "should auto register the service by underscored class name" do
      class FirstService
        include ServiceLayer::Service
      end
      ServiceLayer::Locator.lookup(:first_service).must_be_instance_of(FirstService)
    end

    it "should not auto register the service if there is a name collision with another explicitly registered service for that key" do
      ServiceLayer::Locator.register(:second_service, Array)
      class SecondService
        include ServiceLayer::Service
      end
      ServiceLayer::Locator.lookup(:second_service).must_be_instance_of(Array)
    end
  end
end
