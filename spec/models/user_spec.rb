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

require 'spec_helper'

describe User do
 before { @user = User.new(name:"John Doe", email: "john@doe.com",password: "foobar", password_confirmation: "foobar")}
 subject {@user}
 it {should respond_to(:name)}
 it {should respond_to(:email)}
 it {should respond_to(:password_digest)}	
 it { should respond_to(:password) }
 it { should respond_to(:password_confirmation) } 
 it { should respond_to(:remember_token) }
 it {should be_valid}
 it {should respond_to(:admin)}
 it {should respond_to(:authenticate) }
 it {should_not be_admin }
 it {should respond_to(:microposts)}
 it {should respond_to(:feed)}


describe "when name is not present" do
	before {@user.name=" "}
	it {should_not be_valid}
end
describe "when email is not present" do
before { @user.email = " " }
it { should_not be_valid }
end
describe "when name is too long" do
	before {@user.name="a"*50}
	it {should_not be_valid}
end

describe "When emai; addresses are invalid" do
	it "User should be invalid" do
		addresses=%w[user@foo,com user_at_foo.org example.user@foo.foo@bar_baz.com foo@bar+baz.com]

      addresses.each do |address|
      	@user.email=address
      	@user.should_not be_valid
      end
  end
end

describe "when email format is valid" do
it "should be valid" do
addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
addresses.each do |valid_address|
@user.email = valid_address
@user.should be_valid
end
end
end

describe "When email is already taken" do
	before do
		user_with_same_email =@user.dup
		user_with_same_email.email = @user.email.upcase
		user_with_same_email.save
	end
	it { should_not be_valid}
end
describe "when password is not present" do
before { @user.password = @user.password_confirmation = " " }
it { should_not be_valid }
end
describe "when password doesn't match confirmation" do
before { @user.password_confirmation = "mismatch" }
it { should_not be_valid }
end
describe "when password confirmation is nil" do
before { @user.password_confirmation = nil }
it { should_not be_valid }
end

describe "with a password that's too short" do
before { @user.password = @user.password_confirmation = "a" * 5 }
it { should be_invalid }
end

describe "email address with mixed case" do
let(:mixed_case_email) { "Foo@ExAMPle.CoM" }
it "should be saved as all lower-case" do
@user.email = mixed_case_email
@user.save
@user.reload.email.should == mixed_case_email.downcase
end
end

describe "remember token" do
	before {@user.save} 
	its(:remember_token) {should_not be_blank} # that is equivalent to it {@user.remember_token.should_not be_blank}
end
describe "with admin attribute set to true" do
	before do
		@user.save!
		@user.toggle!(:admin)
	end
	it {should be_admin}
end
describe "accessible attributes" do
	it "admin attribute must not be accessible for mass assignment" do
	expect do
		User.new(admin: true) 
    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
 end
end

describe "micropost associations" do
	before {@user.save}
	let!(:older_micropost) do
		FactoryGirl.create(:micropost,user: @user, created_at: 1.day.ago)
	end
    let!(:newer_micropost) do
		FactoryGirl.create(:micropost,user: @user, created_at: 1.hour.ago)
	end
	it "should have microposts in right order" do
		@user.microposts.should == [newer_micropost,older_micropost]
	end
	it "should destroy associated microposts" do
		microposts=@user.microposts
		@user.destroy
		microposts.each do |micropost|
         expect do 
        	Micropost.find(micropost.id)
         end.should raise_error ActiveRecord::RecordNotFound
       end
   end

   describe "feed of user" do
      let(:unfollowed_post) do
      FactoryGirl.create(:micropost,user: FactoryGirl.create(:user))
      end
      its(:feed) {should_not include(unfollowed_post)}
      its(:feed) {should include(older_micropost)} 
      its(:feed) {should include(newer_micropost)}
   end
 end
end

