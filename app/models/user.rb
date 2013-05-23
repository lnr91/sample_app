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
attr_accessible :name, :email, :password, :password_confirmation,:nick_name
has_many :microposts, dependent: :destroy
has_many :relationships, :foreign_key => 'follower_id', dependent: :destroy
has_many :followed_users, through: :relationships, source: :followed
has_many :reverse_relationships, :foreign_key => 'followed_id',class_name: 'Relationship'
#here we include class name in association..otherwise rails will look for ReverseRelationships class
has_many :followers, through: :reverse_relationships, source: :follower  # Here there is non need for source: :follower
                                                             #bcos it has same name as in relationships table..refer pg 618
has_secure_password
validates :name, presence: true, length: { maximum: 49 }
validates :nick_name, presence: true, length: { maximum: 49 }, uniqueness: { case_sensitive: false }
VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
validates :email, presence: true,format: { with: VALID_EMAIL_REGEX },uniqueness: { case_sensitive: false }
validates :password, presence: true, length: { minimum: 6 }
validates :password_confirmation, presence: true
before_save {self.email.downcase!}  # same as ->  before_save { |user| user.email = email.downcase }
before_save {create_remember_token }
before_create{ create_email_token}

def feed
  Micropost.from_users_followed_including_replies(self)
end

def follow!(other_user)
  self.relationships.create!(followed_id: other_user.id)  #can also write relationships.create!(followed_user: other_user)
end

def unfollow!(other_user)
 self.relationships.find_by_followed_id(other_user.id).destroy
end

def following?(other_user)
  self.relationships.find_by_followed_id(other_user.id)
end


  def send_password_reset
    create_password_reset_token
    self.password_reset_sent_at= Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end

private 
  def create_remember_token
  	self.remember_token = SecureRandom.urlsafe_base64  # If u just say remember_token= ...   then local variable 
  	                                                   # remember_token is created...If u want to access table column
  	                                                   #remember_token...u need to use self.remem...
    end

    def create_email_token
      self.email_token =   SecureRandom.urlsafe_base64
    end

   def create_password_reset_token
     self.password_reset_token =   SecureRandom.urlsafe_base64
   end

end