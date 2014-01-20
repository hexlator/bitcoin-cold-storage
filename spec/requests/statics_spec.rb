require 'spec_helper'
require 'shared_examples'
include ViewsHelper
include FilesHelper

describe "Static" do
	subject { page }

  describe "Home page" do
    before { visit root_path }
    it_should_behave_like 'all pages'   
    it { should have_title full_title(home_title) }
    it { should have_selector('div#catchy', text: catch_phrase) }
    it { should have_selector('div#elevator', text: elevator_pitch) }
    it { should have_link 'freeze_button' }
    it { should have_link 'heatup_button' }
    it { should have_xpath("//a[@class='btn btn-primary'][@title='#{freeze_button_title}']")}
    it { should have_xpath("//a[@class='btn btn-danger'][@title='#{heatup_button_title}']")}    
    describe "freeze button" do
      before { find('#freeze_button',visible: true).click}
      it { should have_title(freeze_title) }
    end
    describe "heatup button" do
      before { find('#heatup_button',visible: true).click }
      it { should have_title(heatup_title) } if file_there?(encrypted_file_path)
    end
  end 

  describe "Help page" do
    before { visit help_path }
    let(:page_title) {'Help'}
    it_should_behave_like "all pages"
    it { should have_title full_title("Help") }
  end

  describe "About page" do
    before { visit about_path }
    it { should have_title full_title("About") }
    it_should_behave_like "all pages"
  end

end