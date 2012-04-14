
require 'rubygems'
require 'hpricot'
require "net/https"
require "uri"
require "socket"
#require 'website'

class SiteCrawler

  def find_or_crawl(domain_name)

    website = Website.find_by_domain_name(domain_name) 


    if website != nil
      return nil if website.is_disabled
    end

    website = crawl_site domain_name

    website

  end
  
  def crawl_site(domain_name)
    ip = check_ip(domain_name)

    if not ip
      puts 'ip was not found for host'
      return nil
    end

    response = fetch('http://' + domain_name)

    if not response
      puts 'response failed'
      return nil
    end

    website = Website.new
    website.domain_name = domain_name
    website.ip_address = ip
    website.server = response['server']
    website.last_indexed = Date.today


    parse_html(response,website)

    website.save

    return website

  end

  def check_ip(domain_name)
    begin
      #SocketError
      ip = IPSocket.getaddress(domain_name)
      return ip
    rescue SocketError => error
      puts "error!!!  " + error
      return nil
    end
  end

  def fetch(uri_str, limit = 10)

    if limit == 0
      puts 'redirect limit reached'
      return nil
    end
  
    response = Net::HTTP.get_response(URI.parse(uri_str))
    case response
    when Net::HTTPSuccess     then return response
    when Net::HTTPRedirection then puts 'redirecting'; return fetch(response['location'], limit - 1)
    else
      #response.error!
      return nil
    end
  end

  def parse_html(response, website)

    doc = Hpricot(response.body)
    
    links = doc/"link[@type='application/rss+xml']"
    puts links

    links.each do |link| 
      puts link.attributes['href']
    end


    titleTags = doc/"title"
    keywordsTag =  doc/"meta[@name='keywords']"
    descriptionTag =  doc/"meta[@name='description']"

    if not titleTags.empty?
      website.title = titleTags[0].inner_text.strip
    end

    if not keywordsTag.empty?
      website.tags = keywordsTag[0].attributes['content']
    end

    if not descriptionTag.empty?
      website.description = descriptionTag[0].attributes['content']
    end


  end 

end







