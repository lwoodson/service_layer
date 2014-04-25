class User < ActiveRecord::Base
  serialize :provider_account_data
  # validation for name
end
