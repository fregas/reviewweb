# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  layout "site"
  before_filter :get_layout_data

  def get_layout_data
      @recent_reviews = Review.recent
      @recent_websites = Website.recent
  end
  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password

  def render_404
    render :text => '404 Error: not found', :status => 404  
  end
end

