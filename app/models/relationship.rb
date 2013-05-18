class Relationship < ActiveRecord::Base
  attr_accessible :followed_id     #purposely removed follower_id ..we dont want it to be accessible for mass assignment
  belongs_to :followed, class_name: 'User'
  belongs_to :follower, class_name: 'User'
  validates :followed_id ,presence: true
  validates :follower_id ,presence: true
end
