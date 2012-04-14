require 'sitecrawler'

class  SearchController < ApplicationController

  def submit
    domain_name = params[:domain_name]

    if domain_name == nil || domain_name == ''
      flash[:notice] = "No domain name was specified"
      redirect_to :action => :not_found
      return
    end


    crawler = SiteCrawler.new
    @website = crawler.find_or_crawl(domain_name)

    if @website == nil
      flash[:notice] =  'site not found, crap.'
      redirect_to :action => :not_found
      return
    end

    redirect_to sitedetails_path domain_name 


  end

  def not_found

  end

end
