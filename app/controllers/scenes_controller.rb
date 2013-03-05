class ScenesController < InheritedResources::Base
  belongs_to :episode
  respond_to :html, :json
  before_filter :authenticate_user!
  load_and_authorize_resource
end
