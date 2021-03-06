require 'spec_helper'
require 'shared_examples'

include ViewsHelper
include PathHelper
include FilesHelper

describe "Inspectors:" do	
	let!(:test_encrypted_pk_path) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv.aes' }	
	let!(:test_decrypted_pk_path) { file_fixtures_directory+'valid/2_private_keys_moohaha.csv' }	
	subject { page }
	before do
	  visit upload_path
	end
	it_should_behave_like 'the upload page'
	describe "flash error and stay on inspect page if no file was attached" do
		before do		  
		  click_button recover_button
		end
		it_should_behave_like 'the upload page'
		it { should have_selector('div.alert.alert-error', text: no_file_loaded_flash)}
	end
	describe "loading an addresses csv file" do
		let!(:test_pa_path) { file_fixtures_directory+'valid/10_addresses.csv' }
		before do
		  attach_file "file", test_pa_path
		  click_button recover_button
		end
		it_should_behave_like 'the addresses page'
		it { should_not have_selector('td.black')}
		it_should_behave_like 'it does not have download buttons'
		describe "and show the addresses correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '1PUBCSPrspWYz6FdJ1CX3SFoQg96Zr62RS') }
			it { should have_selector('td.text_pubkey#address_10', text: '1CXaVvECDcvBb8PFMJAsCPGhqkKwP1tD8K') }
			it { should_not have_selector('td.text_pubkey#address_11') }
			describe "clicking the QR link should generate the QR" do
				before { click_link 'address_qr_btn_1' }
				it { should have_selector('td.black') }
			end
		end
	end
	describe "loading an unencrypted private keys csv file" do
		let!(:test_unencrypted_pk_path) { file_fixtures_directory+'valid/10_private_keys.csv' }	
		before do
		  attach_file "file", test_unencrypted_pk_path
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it { should_not have_selector('td.black')}
		it_should_behave_like 'it does not have download buttons'		
		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '15CzKMKshYnsS3w1ujED3WSQ1T38nAs3CC') }
			it { should have_selector('td.text_prvkey#prvkey_wif_10', text: '5KCG1j27PTVojXXZLf389rKr9PmgiE64NyDQbxFCx1V3c6qtUK4') }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }				
			it { should_not have_selector('td.text_pubkey#address_11') }
			describe "clicking the first addresse QR link should generate the QR" do
				before { click_link 'address_qr_btn_1' }
				it { should have_selector('td.black') }
			end
			describe "clicking the first private keys QR link should generate the QR" do
				before { click_link 'prvkey_qr_btn_1' }
				it { should have_selector('td.black') }
			end						
		end
	end
	describe "loading an encrypted private keys csv.aes file with a password" do
		before do
		  attach_file "file", test_encrypted_pk_path
		  fill_in 'password', with: 'moohaha'
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it does not have download buttons'		
		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '1K17kr8ZCNBEGjZ7gJDV52SiZy9uJYH58U') }
			it { should have_selector('td.text_prvkey#prvkey_wif_2', text: '5Jr89tkiXSU6SxQhX8CA9tfUET5wUwVvcAfxfSz8Snm3uEjSSGL') }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }				
			it { should_not have_selector('td.text_pubkey#address_11') }						
		end
	end
	describe "loading an encrypted private keys csv.aes file with 3 ssss shares using the text interface" do
		let!(:encrypted_pkss_path) { file_fixtures_directory+'valid/private_keys_assafassaf.csv.aes' }	
		before do
		  attach_file "file", encrypted_pkss_path
		  fill_in 'shares', with: "yqYDrPMxpJxd4J4wDRUF3ZY\n3CXayg5rygx7pnnC3WzFnqR3\n3JyctF9DDyWZUnoHwYSkWUL6"
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it does not have download buttons'		
		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '1EuwQKv3mieF3VahcwpAiyGU58KV3qXf8X') }
			it { should have_selector('td.text_prvkey#prvkey_wif_3', text: '5K8SLSAVMmB13Lk2Ao7ojfZDrLRCnMvp5ZRd7igxXNH21mw44Dm') }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }				
			it { should_not have_selector('td.text_pubkey#address_4') }						
		end
	end
	describe "loading an encrypted private keys csv.aes file with 3 ssss shares using the share file upload interface" do
		let!(:encrypted_pkss_path) { file_fixtures_directory+'valid/private_keys_wherethewildthingsare.csv.aes' }	
		let!(:share_1_path) { file_fixtures_directory+'valid/password_share_1_wherethewildthingsare.csv' }	
		let!(:share_2_path) { file_fixtures_directory+'valid/password_share_3_wherethewildthingsare.csv' }	
		let!(:share_3_path) { file_fixtures_directory+'valid/password_share_5_wherethewildthingsare.csv' }	
		before do
		  attach_file "file", encrypted_pkss_path
		  attach_file "password_share_1", share_1_path
		  attach_file "password_share_2", share_2_path
		  attach_file "password_share_3", share_3_path
		  click_button recover_button
		end
		it_should_behave_like 'the private keys page'
		it_should_behave_like 'it does not have download buttons'		
		describe "should show the keys correctly" do
			it { should have_selector('td.text_pubkey#address_1', text: '122W7noC6zD6AEidRgcdX6NpxwRZnm1usH') }
			it { should have_selector('td.text_prvkey#prvkey_wif_3', text: '5KYJ1bwzwVLSf8RtNsELnjFmScT4eTDTDbMUKFVESe5v1b9fnUf') }
			it { should have_selector("td#qr_address_2") }
			it { should have_selector("td#qr_prvkey_wif_2") }				
			it { should_not have_selector('td.text_pubkey#address_11') }						
		end
	end					
	describe "invalid files" do
		describe "foo.bar" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/foo.bar'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: upload_format_error) }	
		end	
		describe "loading an address file with an invalid bitcoin address invalid_address.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_address.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading a file with an invalid addresses format invalid_addresses_format.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_addresses_format.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading an addresses file with an invalid header format invalid_addresses_header.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_addresses_header.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end	
		describe "loading a private keys file with an invalid_format" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_format.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading a file with an invalid header format invalid_header_format.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_header_format.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end	
		describe "loading an pkey file with an invalid format invalid_prvkey_format.csv" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/invalid_prvkey_format.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end	
		describe "loading a private keys file with an invalid bitcoin address prkey_with_invalid_address" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/prkey_with_invalid_address.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading a prkey_with_non_matching_key_pairs" do		
			before do
			  attach_file "file", file_fixtures_directory+'invalid/prkey_with_non_matching_key_pairs.csv'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: incorrect_format_flash) }	
		end
		describe "loading an encrypted private keys file with wrong password" do		
			before do
			  attach_file "file", test_encrypted_pk_path
			  fill_in 'password', with: 'foobar'
			  click_button recover_button			  
			end
			it_should_behave_like 'the upload page'
			it { page.should have_selector('div.alert.alert-error', text: wrong_password_flash) }	
		end															
	end

							
end
