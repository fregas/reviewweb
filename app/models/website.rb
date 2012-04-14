class Website < ActiveRecord::Base
  has_many :reviews , :autosave => false
  has_many :rss_feeds 

  NOT_DISABLED = ' is_disabled = 0 '

  def self.recent(args = {} )
 
    #default paging args
    args[:page] ||= 1
    args[:per_page] ||= 5

    recent_sites = Website.paginate   :page => args[:page], 
                                      :per_page => args[:per_page], 
                                      :order => 'created_at desc' , 
                                      :conditions => NOT_DISABLED 


    return recent_sites
  end
  
  def other_sites    
    @sites = Website.all(:conditions => NOT_DISABLED + " AND ip_address = '#{ip_address}'") if @sites.nil?
    return @sites
  end

  def self.get_for_sitemap(page, max_sites)
    Website.paginate :page => page, :per_page => max_sites, :order => "last_indexed",  :conditions => NOT_DISABLED 
  end

  def self.active_count
    Website.count :conditions => NOT_DISABLED
  end

  def initialize()

    super
    self.is_disabled = false
  end

  
end
