class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.text :provider_account_data
      t.timestamps
    end
  end
end
