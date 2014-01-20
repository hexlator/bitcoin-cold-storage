class FreezersController < ApplicationController
	require 'rqrcode'
	
	before_filter :clear_flash_messages

  def new
		@title=full_title(freeze_title)
		flash[:new] = false
	end
	
	def create
		@title=full_title(freeze_title)
		@coldstorage=ColdStorage.new
		howmany=params[:howmany].to_i
		if howmany > 0 && howmany < @coldstorage.keys_limit+1					
			@coldstorage=ColdStorage.new(params[:password],howmany)			
			Rails.cache.clear
			Rails.cache.write(:cold, @coldstorage, expires_in: howmany.minute )
			flash[:new]=true
			redirect_to cold_view_path 
		else
			flash.now[:error] = addresses_range_notice
			render 'new'
		end
	end
  
  def show
  	@title=cold_view_title  	
		@coldstorage=Rails.cache.read(:cold)
		@qm=Quartermaster.new
		if @coldstorage.nil? || !flash[:new]
			redirect_to root_path 
		else
			@keys=@coldstorage.keys
			@howmany=@coldstorage.howmany
			@password=@coldstorage.password
			@entropy=PasswordGenerator.new.calculate_entropy(@password)
			@alphabet=PasswordGenerator.new.alphabet
			@explanation=entropy_explanation(@password.length, @alphabet,@entropy)
			html=render_to_string
			plaintext=inject_css(html)
			encrypted=encrypt_my_file(plaintext,@password)
			@qm.save_coldstorage_files(plaintext,encrypted)
			# send_data('foo', filename: 'foo.txt')
		end
  end

  private

	  def freezers_params
	    params.require(:keys).permit(:howmany, :password)
	  end

end

# send_data(inject_css(render_to_string), :filename => "colds.html") if @download=='plaintext'
# send_data(encrypt_my_page(inject_css(render_to_string),@password), :filename => "cold.html.aes") if @download=='encrypted'