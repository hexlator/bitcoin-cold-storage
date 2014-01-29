shared_examples_for "all pages" do 
	it { should have_selector('header.navbar.navbar-fixed-top.navbar-inverse') }
	it { should have_link(app_title, href: root_path) }	
	it { should have_link('navbar_freeze', href: freeze_path) }	
	it { should have_link('navbar_inspect', href: inspect_path) }
	it { should have_link('About', href: about_path) }
	it { should have_link('Help', href: help_path) }
end	

shared_examples_for "the freeze page" do
	it { should have_title full_title(freeze_page_title) }
	it { should have_selector('h2', freeze_page_header)}
	it { should have_selector('input#howmany') }
	it { should have_xpath("//input[@value=0]")}
	it { should have_button generate_button}
	it { should have_selector('input#password.input-xxlarge') }
end

shared_examples_for "the inspect page" do
	it { should have_title full_title(inspect_page_title) }
	it { should have_selector('h2', inspect_page_header)}
	it { should have_xpath("//input[@type='file']")}
	it { should have_button inspect_button}
	it { should have_selector('input#password.input-xxlarge') }
end

shared_examples_for "the private keys page" do	
	it { should have_title full_title(private_keys_title) }
	it { should have_selector('th', text: 'Bitcoin Address') }		
	it { should have_selector('th', text: 'Private Key') }		
	it { should have_selector('table.private_output#private_output') }		
	it { should have_selector("td#address_1") }
	it { should have_selector("td#qr_address_1") }
	it { should have_selector("td#prvkey_wif_1") }
	it { should have_selector("td#qr_prvkey_wif_1") }	
	it { should_not have_selector('div.alert.alert-keys')}
	it { should have_link 'addres_qr_btn_1'}
	it { should have_link 'prvkey_qr_btn_1'}
end

shared_examples_for "the addresses page" do	
	it { should have_title full_title(addresses_title) }
	it { should have_selector('th', text: 'Bitcoin Address') }		
	it { should_not have_selector('th', text: 'Private Key') }	
	it { should have_selector('table.public_output#public_output') }		
	it { should have_selector("td#address_1") }
	it { should have_selector("td#qr_address_1") }
	it { should_not have_selector("td#prvkey_wif_1") }	
	it { should_not have_selector('div.alert.alert-keys')}
	it { should have_link 'addres_qr_btn_1'}
	it { should_not have_link 'prvkey_qr_btn_1'}
end

shared_examples_for 'it has download buttons' do
  it { should have_xpath("//a[@class='btn btn-danger'][text()='#{save_non_encrypted_button}']")} 
  it { should have_xpath("//a[@class='btn btn-success'][text()='#{save_encrypted_button}']")} 
  it { should have_xpath("//a[@class='btn btn-success'][text()='#{save_addresses_button}']")}    
end

shared_examples_for 'it does not have download buttons' do
  it { should_not have_xpath("//a[@class='btn btn-danger'][text()='#{save_non_encrypted_button}']")} 
  it { should_not have_xpath("//a[@class='btn btn-success'][text()='#{save_addresses_button}']")}    
end

shared_examples_for "the heatup page" do
	it { should have_title full_title(heatup_title) }
	it { should have_selector('input#recover_password.input-xxlarge') }
	it { should have_selector('input#recover_button') }
end

shared_examples_for "it failed decryption" do
	it { should_not have_content('Bitcoin Address') }
	it { should_not have_content('Private Key') }
	it { should_not have_selector('div.normal', text: '(Wallet Import Format)') }
	it { should_not have_selector("td#address_1") }
	it { should_not have_selector("td#prvkey_wif_1") }
	it { should have_selector('div.alert.alert-error', text: failed_decryption_message) }
end

shared_examples_for 'it saved the files' do
	specify{File.exist?(pa_path).should be_true }			
	specify{(File.ctime(pa_path).to_f-Time.now.to_f).to_i.should be < 1}
	specify{File.exist?(non_encrypted_pk_path).should be_true }
	specify{(File.ctime(non_encrypted_pk_path).to_f-Time.now.to_f).to_i.should be < 1}
	specify{File.exist?(encrypted_pk_path).should be_true }
	specify{(File.ctime(encrypted_pk_path).to_f-Time.now.to_f).to_i.should be < 1}		
end


shared_examples_for "flash should go away" do
	describe "when navigating home" do
		before { click_link app_title }
		it { should_not have_selector('div.alert')}
	end
	describe "when navigating to Help" do
		before { click_link 'Help' }
		it { should_not have_selector('div.alert')}
	end
	describe "when navigating to About" do
		before { click_link 'About' }
		it { should_not have_selector('div.alert')}
	end						
	describe "when navigating to freeze page" do
		before { click_link freeze_button }
		it { should_not have_selector('div.alert')}
	end		
	describe "when navigating to the inspect page" do
		before { click_link inspect_button }
		it { should_not have_selector('div.alert')}
	end		
end