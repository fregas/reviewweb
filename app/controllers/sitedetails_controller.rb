class SitedetailsController < ApplicationController
  include CaptchaHelper

  
  def index
    get_website
    @new_review = Review.new
    #logger.debug "disabled: " +  @website.is_disabled.to_s
    if @website == nil || @website.is_disabled 
      render_404
      #raise "No domain found.  Lame!" 
    end
  end
  
  def add_review  

    get_website

    @new_review = Review.new(params[:new_review])
    @valid = true

    #have to check review normal validation first before
    #adding captcha errors, because model validation resets any errors
    check_review
    check_captcha
      
    if not @valid      
      render :action => "index"
      return
    end


    @website.reviews << @new_review
    flash[:notice] = "Your review has been added"
    redirect_back 
  end


  protected

  def get_website
    if @website == nil
      @website = Website.find_by_domain_name params[:domain_name]      
    end
    @website
  end


  

  def redirect_back
     redirect_to sitedetails_url( :domain_name => params[:domain_name]) + "#reviews"

  end

  def check_review
    if @new_review.invalid?
      @valid = false
    end
  end

  def check_captcha
    if not captcha_passed?
      @new_review.errors.add_to_base "Captcha failed!"      
      @valid = false
    end
    
  end


end
