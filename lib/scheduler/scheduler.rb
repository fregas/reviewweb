$LOAD_PATH << "./vendor/cache/"

#Dir.glob(File.join("vendor", "gems", "*", "lib")).each do |lib|
#  $LOAD_PATH.unshift(File.expand_path(lib))
#end



require 'rubygems'
require 'bundler'
Bundler.setup

require 'sequel'
require 'net/http'   
require 'sequel/extensions/migration'

class Scheduler
  
  def initialize
    @www = "www."
    
    @db = Sequel.amalgalite("populatesitechunks.db") 
    p @db
    Sequel::Migrator.run(@db, '.')
    
    @domains = @db[:DomainsProcessed]
    
  end  
  
  def file_name=(file)
    @file_name = file
  end
  def ext
    @file_name
  end  
  
  def ext=(extension)
    @ext = extension
  end
  def ext
    @ext
  end
  
  def start_text= (starttxt)
    @start_text = starttxt
  end
  
  def start_text
    @start_text
  end
  
  
  
  def start
    
    open_file()  
    
    #for i in 1..10      
    spawn_thread()
    #end   
    
    
  end
  
  def spawn_thread
    #t = Thread.new do
    while line = @zone_file.readline do    
      
      line = line.downcase
      domain = line.split(" ")[0]
      domain = @www + domain + @ext
      
      p "domain name is: " + domain + " and was found in db?: " + has_domain?(domain).to_s
            
      if not has_domain?(domain)
        print "saving domain name " + domain
        begin
          post_domain(domain)
          sleep(0.100)
        rescue Timeout::Error
          next
        end       
        
      end
      
      mark_domain(domain)
      
    end
    #end
    
    #t.join    
  end
  
  def open_file
    if @start_text == "" then return
      
    end
    #print File.readable?(@file_name)
    @zone_file = File.open(@file_name, "r+")  
    found_start_text = false
    
    i = 0
    
    while found_start_text == false do
      current_line = @zone_file.readline
      found_start_text = starts_with?(current_line, @start_text)    
      i+=1  
    end
    
    max_line_number = max_line?  
    
    puts max_line_number.to_s
        
    for line in (i..max_line_number)
      current_line = @zone_file.readline
      i+=1
    end
    
    puts i.to_s
      
     
  end
  
  def starts_with?(str, prefix)
    prefix = prefix.to_s
    return str[0, prefix.length] == prefix
  end  
  
  def post_domain(domain_name)
    url = URI.parse('http://www.sitechunks.com/sitedetail.mvc')
    
    res = Net::HTTP.post_form(url, {'domain'=>domain_name})
    
    
    p res.header    
  end 
  
  def mark_domain(domain_name)
    @domains.insert(:domain_name => domain_name, :line_number => @domains.count + 1)    
    puts "Item count: #{@domains.count}"
  end
  
  def has_domain?(domain_name)
    return @domains.filter(:domain_name => domain_name).count > 0
  end
  
  def max_line?()
    @domains.max(:line_number)
  end 
  
end
