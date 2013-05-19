class Micropost < ActiveRecord::Base
  attr_accessible :content
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
  belongs_to :user
  default_scope order: 'microposts.created_at DESC'
  before_save :extract_in_reply_to
  @@reply_to_regexp = /\A@([^\s]*)/


  def self.from_users_followed(user)
    followed_users_ids = "Select followed_id from relationships where follower_id=:user_id"
    where("user_id IN (#{followed_users_ids}) or user_id= :user_id or to_id= :user_id",user_id: user.id)   #2nd arg can also be written as user
  end

  def self.from_users_followed_including_replies(user)
    followed_users_ids = "Select followed_id from relationships where follower_id=:user_id"
    where("user_id IN (#{followed_users_ids}) or user_id= :user_id or to_id= :user_id",user_id: user.id)   #2nd arg can also be written as user
  end

  private
   def extract_in_reply_to
     if match = @@reply_to_regexp.match(content)
       user = User.find_by_nick_name(match[1])
     end
     self.to_id= user.id if user
   end

end