class AddEmailTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :email_token, :string
    add_column :users, :email_activated, :boolean
  end

end
