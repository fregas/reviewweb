include StringHelper

class Review < ActiveRecord::Base
  belongs_to :website , :autosave => false
  validates_presence_of  :rating, :reviewer_email, :comment

  def self.recent
     recent_reviews = Review.all :limit => 10, :order => 'created_at desc', :include => [:website]
  end

  def comment_brief
    commentb = comment
    commentb = commentb.gsub(/<.*?>/,'')
    commentb = truncate_words(commentb, 8)     
  end
end
