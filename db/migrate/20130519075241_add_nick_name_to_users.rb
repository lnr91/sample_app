class AddNickNameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :nick_name, :string
    add_column :microposts, :to_id, :integer
  end
end
