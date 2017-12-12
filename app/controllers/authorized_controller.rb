class AuthorizedController < ApplicationController

  before_action do
    puts "cookies['token']: #{cookies['token']}"
    redirect_to '/auth/auth' unless cookies['token']
  end

end
