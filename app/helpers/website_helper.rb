module WebsiteHelper

  def link_to_site(website)
    link_to website.domain_name, sitedetails_path(  website.domain_name)
  end

end
