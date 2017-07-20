class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  APP_ID = '386'
  APP_SECRET = Rails.application.secrets.geni_secret
  SITE = 'https://www.geni.com'

  def client
    OAuth2::Client.new(APP_ID, APP_SECRET,
                       site: SITE,
                       parse_json: true,
                       access_token_path: '/oauth/token'
    )
  end

end
