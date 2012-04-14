class HomeController < ApplicationController

  def index
    @websites = Website.recent :page => 1, :per_page => 5
  end
end
