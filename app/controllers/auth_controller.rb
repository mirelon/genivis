class AuthController < ApplicationController

  def auth
    redirect_to client.auth_code.authorize_url(
        redirect_uri: redirect_uri
    )
  end

  def callback
    puts params[:code]
    redirect_uri.tap{|ii| puts ii}
    token = client.auth_code.get_token(params[:code], redirect_uri: redirect_uri.tap{|ii| puts ii})
    cookies[:token] = {value: token.token, expires: 1.year.from_now}
    redirect_to '/'
  end

  def redirect_uri
    uri = URI.parse(request.url)
    uri.path = '/auth/callback'
    uri.query = nil
    uri.to_s
  end

end
