require 'spec_helper'

describe Relationship do
  let(:follower) {FactoryGirl.create(:user)}
  let(:followed) {FactoryGirl.create(:user)}
  let(:relationship) {follower.relationships.build(followed_id: followed.id)}
  subject {relationship}
  it {should be_valid}
  it {should respond_to(:follower_id)}
  it {should respond_to(:followed_id)}
  its(:follower) {should== follower}
  its(:followed) {should== followed}
  describe "accessible attributes" do

     it "follower_id must not be mass assigned" do
       expect do Relationship.new(follower_id: follower.id)
            end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
       end
  end

  describe "when followed_id is nil" do
    before {relationship.followed_id=nil}
    it {should_not be_valid}
  end
  describe "when follower_id is nil" do
    before {relationship.follower_id=nil}
    it {should_not be_valid}
  end
  end
