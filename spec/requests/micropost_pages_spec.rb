require 'spec_helper'

describe "MicropostPages" do
  subject {page}
  let(:user) {FactoryGirl.create(:user)}
  before {sign_in user}
    describe "micropost creation" do
    	before {visit root_path}
    	describe "with invalid information" do
    		it "should not create a micropost" do
    			expect {click_button 'Post'}.should_not change(Micropost,:count)
             end

             describe "error message" do
             	before {click_button 'Post'}
             	it {should have_content('error')}
             end
         end
        describe "with valid information" do
        	before do
        		fill_in 'micropost_content',with: "Lorem ipsum"
            end
          it "should create a micropost " do
          	expect {click_button 'Post'}.should change(Micropost,:count).by(1)
          end
      end
  end
  describe "micropost deletion" do
    describe "as a correct user" do
       before do 
        FactoryGirl.create(:micropost, user: user) 
        visit root_path
      end
     it "should delete a micropost" do
      expect {click_link 'delete'}.should change(Micropost,:count).by(-1)
    end
  end
 end


end
