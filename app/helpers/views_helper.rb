module ViewsHelper

	def app_title
		'CoinCooler'
	end

	def full_title(string)
		app_title + " - " + string.to_s
	end

	def home_title
		'Home'
	end

	def heatup_header
		'Recovered Addresses'
	end

	def failed_decryption_message
		'Decryption have failed. Try again..'
	end

	def generate_button
		'Generate Addresses'
	end

	def recover_button
		'Recover Addresses'
	end

	def howmany_placeholder
		'How many?'
	end

	def recover_passwd_placeholder
		'Your cold storage password'
	end	

	def cold_view_title
		'Inspect your new cold storage addresses'
	end

	def hot_view_title
		'Inspect the addresses recovered from cold storage'
	end	

	def freeze_title
		'Freeze'
	end

	def heatup_title
		'Heat-up'
	end

	def freeze_button_title
		'Generate an encrypted file containing Bitcoin Addresses for Cold Storage'
	end

	def heatup_button_title
		'Decrypt and inspect your Cold Stored Bitcoin Addresses'
	end

	def password_placeholder
		'Your Password (optional)'
	end

	def catch_phrase
		'Simple Bitcoin Cold Storage'
	end

	def elevator_pitch
		'Create and recover encrypted addresses on your offline Raspberry Pi'
	end
	def addresses_range_notice
		'You can request at most ' + keys_limit.to_s + ' addresses.'
	end

	def entropy_explanation(length, alphabet, entropy)
		size=[(entropy -1).round.to_i,0].max.to_s
		'A brute force search for a word of length '+length.to_s + ' in the alphabet [' + alphabet.to_s + '] requires ~ 2^' + size + ' trials, on average.'
	end

	def get_css_from_file
		file = File.join(Rails.root, 'app/helpers/download.css')
		File.read(file)
	end

	def inject_css(html_string,css_string=get_css_from_file)
		remove_tag=html_string[0..-(' </html>'.length)]
		insert_css=remove_tag<<'<style type="text/css">'<<css_string<<'</style></html>'		
	end

	def trim_css(html_string)
		string=html_string.to_s
		position=string.to_s.index('<style type="text/css">')
		if position 
			return string[0..(position-1)]+'</html>'
		else
			return string
		end			
	end

	def extract_keys_html(html_string)
		string=html_string.to_s
		start_mark='<div class="heatup_begin">'
		finish_mark='<div class="heatup_end">'
		start_index=string.index(start_mark)
		finish_index=string.index(finish_mark)
		start=start_index+start_mark.length if start_index
		finish=finish_index-1 if finish_index
		if start && finish && (finish > start)
			return string[start..finish]
		else
			return string
		end		
	end

  def clear_flash_messages
  	flash[:error].clear if flash[:error] 
  end	

end