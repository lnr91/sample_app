class Micropost < ActiveRecord::Base
  attr_accessible :content
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  belongs_to :user
  default_scope order: 'microposts.created_at DESC'

  def self.from_users_followed(user)
     followed_users_ids = "Select followed_id from relationships where follower_id=:user_id"
     where("user_id IN (#{followed_users_ids}) or user_id= :user_id",user_id: user.id)   #2nd arg can also be written as user
  end
end
