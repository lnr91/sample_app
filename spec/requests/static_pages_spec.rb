require 'spec_helper'
describe "Static pages" do
  subject { page }

  shared_examples_for "all static pages" do
    it { should have_selector('h1', text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end



  describe "Home Page" do
    before { visit root_path }
    it_should_behave_like "all static pages"
    let(:heading) { 'Sample App' }
    let(:page_title) { '' }
    it { should_not have_selector 'title', text: '| Home' }
    it "should have the right links on the layout" do
      visit root_path
      click_link "About"
      page.should have_selector 'title', text: full_title('About Us')
      click_link "Help"
      page.should have_selector 'title', text: full_title('Help')
      click_link "Contact"
      page.should have_selector 'title', text: full_title('Contact')
      click_link "Home"
      click_link "Sign up now!"
      page.should have_selector 'title', text: full_title('Sign Up')
      click_link "sample app"
      #page.should # fill in
    end
     
         describe "for signed in users" do
           let(:user) {FactoryGirl.create(:user)}
           before do
            FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
            FactoryGirl.create(:micropost, user: user, content: "Bull shit")
           sign_in user
           visit root_path
           end
           it "should render users feed" do
             user.feed.each do |item|
               page.should have_selector("li##{item.id}",text:item.content)
             end
           end
           it {should have_selector("span.count",text: "#{user.microposts.count} microposts")}
           describe 'follower/following counts' do
             let(:other_user) {FactoryGirl.create(:user)}
             before do
               other_user.follow!(user)
               visit root_path
             end
             it {should have_link('0 following',href: following_user_path(user))}
             it {should have_link('1 followers',href: followers_user_path(user))}
           end

           describe "replies must show up in feed" do
             let(:other_user) { FactoryGirl.create(:user) }
             before do
               FactoryGirl.create(:micropost, user: other_user, content: "@#{user.nick_name} how are you")
               visit root_path
             end
             it {should have_content(other_user.microposts.first.content)}
           end
         end
         describe "pagination of microposts" do
          let(:user) {FactoryGirl.create(:user)}
          before do
            31.times {FactoryGirl.create(:micropost,user: user)}
            sign_in user
            visit root_path
          end
          it {should have_selector("div.pagination")}
          it "should show each micropost " do
        user.feed.paginate(page: 1).each do |feed_item|
        page.should have_selector('li', text: feed_item.content) 
      end
    end
  end
  end
  describe "Help page" do
    before { visit help_path }
    it_should_behave_like "all static pages"
    let(:heading) { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
  end
  describe "About page" do
    before { visit about_path }
    it_should_behave_like "all static pages"
    let(:heading) { 'About' }
    let(:page_title) { 'About Us' }
    it_should_behave_like "all static pages"
  end
  describe "Contact page" do
    before { visit contact_path }
    it_should_behave_like "all static pages"
    let(:heading) { 'Contact' }
    let(:page_title) { 'Contact' }
    it_should_behave_like "all static pages"
  end

  end