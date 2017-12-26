class AuthorizedController < ApplicationController

  rescue_from OAuth2::Error do
    cookies.delete :token
    redirect_to '/auth/auth'
  end

  before_action do
    puts "cookies['token']: #{cookies['token']}"
    redirect_to '/auth/auth' unless cookies['token']
  end

end
