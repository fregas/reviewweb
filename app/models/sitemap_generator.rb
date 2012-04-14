class SitemapGenerator

  MaxSites = 50000

  attr_accessor :root_url

  def initialize(root_url)
    @root_url = root_url
  end

  def sitemap_index(page)

    #@websites = Website.paginate :page => page, :per_page => MaxSites, :order => "last_indexed"
    @websites = Website.get_for_sitemap page, MaxSites


    xml_str = ""
    xml = Builder::XmlMarkup.new(:target => xml_str, :indent => 3)

    xml.instruct!
    xml.urlset(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') do
      @websites.each do |web|
          xml.url do
            xml.loc(root_url + "/" + web.domain_name)
            xml.lastmod(web.last_indexed.strftime("%Y-%m-%dT%H:%M:%S+00:00")) unless web.last_indexed.nil?
          end
        end
      end

      return xml_str
    end

    def sitemap_count

      websites_count = Website.active_count 
      number_of_indexes = websites_count / MaxSites
      mod_num = websites_count.to_f % MaxSites

      if mod_num != 0
        number_of_indexes += 1 
      end

      #lastmod = Date.today

      xml_str = ""
      xml = Builder::XmlMarkup.new(:target => xml_str, :indent => 3)
      xml.instruct!
      xml.comment! "total sites: " + websites_count.to_s + ", number of indexes: " + number_of_indexes.to_s

      xml.sitemapindex(:xmlns=>'http://www.sitemaps.org/schemas/sitemap/0.9') do
      
        for i in 1..number_of_indexes do
          xml.sitemap do
            xml.loc( "#{root_url}/sitemap-detail-#{i}.xml" )
            #xml.lastmod(lastmod.strftime("%Y-%m-%dT%H:%M:%S+00:00"))

          end

        end

      end
      
      return xml_str
    end
 end



