class EpisodesController < InheritedResources::Base
  respond_to :html, :json
  load_and_authorize_resource
  before_filter :authenticate_user!
end
