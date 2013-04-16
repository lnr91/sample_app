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
let(:heading) {'Sample App'}
let(:page_title) {''}
it { should_not have_selector 'title', text: '| Home' }
it "should have the right links on the layout" do
visit root_path
click_link "About"
page.should have_selector 'title', text: full_title('About Us')
click_link "Help"
page.should # fill in
click_link "Contact"
page.should # fill in
click_link "Home"
click_link "Sign up now!"
page.should # fill in
click_link "sample app"
page.should # fill in
end
end
describe "Help page" do
before { visit help_path }
it_should_behave_like "all static pages"
let(:heading) {'Help'}
let(:page_title) {'Help'}
it_should_behave_like "all static pages"
end
describe "About page" do
before { visit about_path }
it_should_behave_like "all static pages"
let(:heading) {'About'}
let(:page_title) {'About Us'}
it_should_behave_like "all static pages"
end
describe "Contact page" do
before { visit contact_path }
it_should_behave_like "all static pages"
let(:heading) {'Contact'}
let(:page_title) {'Contact'}
it_should_behave_like "all static pages"
end
end