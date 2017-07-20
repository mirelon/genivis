require 'net/http'

class FamilyController < AuthorizedController
  def show
    @profile_id = params[:profile_id]
    token   = OAuth2::AccessToken.new(client, cookies['token'])
    node_id = "-#{@profile_id}" if @profile_id
    @family  = Family.new(token.get("/api/profile#{node_id}/immediate-family").parsed)
  end
end
