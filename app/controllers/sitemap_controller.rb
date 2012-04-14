class SitemapController < ActionController::Base 

  before_filter :init_generator
  #caches_action :index, :sitemapindex

  def init_generator
    @sitemap_generator = SitemapGenerator.new  "http://" + request.host_with_port #i.e."http://www.reviewsomewebsites.com"
  end

  def generator
    @sitemap_generator
  end

  def detail
    xml_str = generator.sitemap_index params[:page]
    render :xml => xml_str
  end

  def index

    results = generator.sitemap_count

    render  :xml => results
  end
  
end
