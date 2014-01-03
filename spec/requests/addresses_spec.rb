require 'spec_helper'
include ViewsHelper

describe "Addresses" do
	subject { page }
	before { visit root_path }
	it { should have_title full_title(setup_title) }
	it { should have_button howmany_button_title}
	it { should have_selector('input#howmany') }
	it { should have_xpath("//input[@value=1]")}
	describe "submitting should stay on setup if the request was not a positive number is requested" do
		before do
		  fill_in 'howmany', with: ''
		  click_button howmany_button_title			  
		end
		it { should have_title setup_title }
	end
	describe "if the requested number is zero, redirect home" do
		before do
		  fill_in 'howmany', with: 0
		  click_button howmany_button_title
		  visit private_path
		end
		it { should have_title setup_title }
	end			
	describe "submitting should redirect to private if a positive number is requested" do
		before do
		  fill_in 'howmany', with: '2'
		  click_button howmany_button_title			  
		end
		it { should have_title private_title }
		describe "cookie persistance of howmany" do
			before { visit root_path }
			it { find_field('howmany').value.should == '2' }
			it { find_field('howmany').value.should_not == '' }
		end
	end
	describe "private page should show the correct number of addresses" do
		let!(:num) { 2 }
		before do
		  fill_in 'howmany', with: num
		  click_button howmany_button_title			  
		end
		it { should have_title full_title(private_title) }
		it { should have_selector('th', text: 'Bitcoin Address') }		
		it { should have_selector('table.private_output#private_output') }						
		(1..2).each do |x|
			it { should have_selector("td#address_#{x}") }
			it { should have_selector("td#qr_address_#{x}") }
			it { should have_selector('div.qr_address') }
			it { should have_selector("td#prvkey_wif_#{x}") }
			it { should have_selector("td#qr_prvkey_wif_#{x}") }
			it { should have_selector('div.qr_prvkey') }				
		end
	end
end
