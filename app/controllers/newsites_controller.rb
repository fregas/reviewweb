class NewsitesController < ApplicationController


  def index
    @websites = Website.recent :page => params[:page], :per_page => 10
  end
end
