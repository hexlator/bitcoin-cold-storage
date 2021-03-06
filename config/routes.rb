Coldcoin::Application.routes.draw do

 	resources :freezers, only: [:new, :create, :addresses,:private_keys]
 	resources :inspectors, only: [:new, :create, :addresses, :private_keys]
 
 	root                        to: "static#home"
  match "/help",              to: 'static#help',              via: :get
  match "/about",             to: 'static#about',             via: :get

  match "/freeze",  				  to: 'freezers#new',   					via: :get
  match "/new_addresses",		  to: 'freezers#addresses',				via: :get
  match "/new_keys",          to: 'freezers#private_keys',		via: :get
  match	"/download",				  to: 'freezers#download',				via: :get
  match "/upload",	          to: 'inspectors#new',           via: :get
  match "/inspect_addresses", to: 'inspectors#addresses',     via: :get
  match "/inspect_keys",      to: 'inspectors#private_keys',  via: :get


end
