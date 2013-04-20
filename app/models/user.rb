# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
attr_accessible :name, :email, :password, :password_confirmation
has_secure_password
validates :name, presence: true, length: { maximum: 49 }
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
validates :email, presence: true,format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
validates :password, presence: true, length: { minimum: 6 }
validates :password_confirmation, presence: true
before_save {self.email.downcase!}  # same as ->  before_save { |user| user.email = email.downcase }
before_save {create_remember_token }


private 
  def create_remember_token
  	self.remember_token = SecureRandom.urlsafe_base64  # If u just say remember_token= ...   then local variable 
  	                                                   # remember_token is created...If u want to access table column
  	                                                   #remember_token...u need to use self.remem...
end
end